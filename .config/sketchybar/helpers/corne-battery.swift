import Foundation
import CoreBluetooth
import Darwin

final class Reader: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    private var central: CBCentralManager!
    private let batteryService = CBUUID(string: "180F")
    private let hidService = CBUUID(string: "1812")
    private let batteryLevel = CBUUID(string: "2A19")
    private var peripherals: [UUID: CBPeripheral] = [:]
    private var connectedIDs = Set<UUID>()
    private var completedIDs = Set<UUID>()
    private var servicesByPeripheral: [UUID: [CBService]] = [:]
    private var completedServices: [UUID: Set<Int>] = [:]
    private var results: [UUID: [Int: Int]] = [:]
    private var characteristicIndexes: [ObjectIdentifier: (peripheralID: UUID, serviceIndex: Int)] = [:]
    private var done = false
    private var printed = false

    func run(timeout: TimeInterval = 3) {
        central = CBCentralManager(delegate: self, queue: DispatchQueue.main)

        let deadline = Date().addingTimeInterval(timeout)
        while !done && Date() < deadline {
            RunLoop.main.run(mode: .default, before: Date().addingTimeInterval(0.1))
        }

        if !printed {
            printResults()
        }
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        guard central.state == .poweredOn else {
            done = true
            return
        }

        let connected = central.retrieveConnectedPeripherals(withServices: [batteryService])
            + central.retrieveConnectedPeripherals(withServices: [hidService])
        let cornes = Dictionary(
            connected
                .filter { ($0.name ?? "").localizedCaseInsensitiveContains("corne") }
                .map { ($0.identifier, $0) },
            uniquingKeysWith: { first, _ in first }
        )

        guard !cornes.isEmpty else {
            done = true
            return
        }

        peripherals = cornes
        connectedIDs = Set(cornes.keys)
        for corne in cornes.values {
            corne.delegate = self
            central.connect(corne, options: nil)
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices([batteryService])
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        completePeripheral(peripheral.identifier)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        let identifier = peripheral.identifier
        guard error == nil else {
            completePeripheral(identifier)
            return
        }

        let services = (peripheral.services ?? []).filter { $0.uuid == batteryService }
        servicesByPeripheral[identifier] = services
        guard !services.isEmpty else {
            completePeripheral(identifier)
            return
        }

        for service in services {
            peripheral.discoverCharacteristics([batteryLevel], for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        let identifier = peripheral.identifier
        guard let index = servicesByPeripheral[identifier]?.firstIndex(where: { $0 === service }),
              error == nil,
              let characteristic = service.characteristics?.first(where: { $0.uuid == batteryLevel }) else {
            if let index = servicesByPeripheral[identifier]?.firstIndex(where: { $0 === service }) {
                completeService(identifier, index: index)
            }
            return
        }

        characteristicIndexes[ObjectIdentifier(characteristic)] = (identifier, index)
        peripheral.readValue(for: characteristic)
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let (identifier, index) = characteristicIndexes.removeValue(forKey: ObjectIdentifier(characteristic)) else {
            return
        }

        if error == nil, let value = characteristic.value?.first {
            results[identifier, default: [:]][index] = Int(value)
        }
        completeService(identifier, index: index)
    }

    private func completeService(_ identifier: UUID, index: Int) {
        completedServices[identifier, default: []].insert(index)
        if completedServices[identifier]?.count == servicesByPeripheral[identifier]?.count {
            completePeripheral(identifier)
        }
    }

    private func completePeripheral(_ identifier: UUID) {
        completedIDs.insert(identifier)
        if completedIDs == connectedIDs {
            done = true
            printResults()
            for peripheral in peripherals.values {
                central.cancelPeripheralConnection(peripheral)
            }
        }
    }

    private func printResults() {
        guard !printed else { return }
        printed = true

        let sortedIDs = connectedIDs.sorted { lhs, rhs in
            let leftName = peripherals[lhs]?.name ?? ""
            let rightName = peripherals[rhs]?.name ?? ""
            if leftName.localizedCaseInsensitiveCompare(rightName) != .orderedSame {
                return leftName.localizedCaseInsensitiveCompare(rightName) == .orderedAscending
            }
            return lhs.uuidString < rhs.uuidString
        }
        let levels = sortedIDs.flatMap { identifier in
            (results[identifier] ?? [:]).keys.sorted().compactMap { results[identifier]?[$0] }
        }

        if !levels.isEmpty {
            print(levels.map(String.init).joined(separator: "/"))
            fflush(stdout)
        }
    }
}

Reader().run()
