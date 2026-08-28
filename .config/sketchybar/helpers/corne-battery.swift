import Foundation
import CoreBluetooth
import Darwin

final class Reader: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    private var central: CBCentralManager!
    private var peripheral: CBPeripheral?
    private let batteryService = CBUUID(string: "180F")
    private let hidService = CBUUID(string: "1812")
    private let batteryLevel = CBUUID(string: "2A19")
    private var services: [CBService] = []
    private var characteristicIndexes: [ObjectIdentifier: Int] = [:]
    private var results: [Int: Int] = [:]
    private var done = false

    func run(timeout: TimeInterval = 3) {
        central = CBCentralManager(delegate: self, queue: DispatchQueue.main)

        let deadline = Date().addingTimeInterval(timeout)
        while !done && Date() < deadline {
            RunLoop.main.run(mode: .default, before: Date().addingTimeInterval(0.1))
        }
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        guard central.state == .poweredOn else {
            done = true
            return
        }

        let connected = central.retrieveConnectedPeripherals(withServices: [batteryService]) + central.retrieveConnectedPeripherals(withServices: [hidService])
        guard let corne = connected.first(where: { ($0.name ?? "").localizedCaseInsensitiveContains("corne") }) else {
            done = true
            return
        }

        peripheral = corne
        corne.delegate = self
        central.connect(corne, options: nil)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices([batteryService])
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        done = true
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard error == nil else {
            done = true
            return
        }

        services = (peripheral.services ?? []).filter { $0.uuid == batteryService }
        guard !services.isEmpty else {
            done = true
            return
        }

        for service in services {
            peripheral.discoverCharacteristics([batteryLevel], for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard error == nil,
              let index = services.firstIndex(where: { $0 === service }),
              let characteristic = service.characteristics?.first(where: { $0.uuid == batteryLevel }) else {
            done = true
            return
        }

        characteristicIndexes[ObjectIdentifier(characteristic)] = index
        peripheral.readValue(for: characteristic)
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil,
              let index = characteristicIndexes[ObjectIdentifier(characteristic)],
              let value = characteristic.value?.first else {
            done = true
            return
        }

        results[index] = Int(value)
        if results.count == services.count {
            let label = results.keys.sorted().map { String(results[$0]!) }.joined(separator: "/")
            print(label)
            fflush(stdout)
            central.cancelPeripheralConnection(peripheral)
            done = true
        }
    }
}

Reader().run()
