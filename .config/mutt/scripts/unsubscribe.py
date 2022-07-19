#!/usr/bin/env python3
''' mutt-unsubscribe.py (c) 2022 Matthew J. Ernisse <matt@going-flying.com>
All Rights Reserved.

Redistribution and use in source and binary forms,
with or without modification, are permitted provided
that the following conditions are met:

    * Redistributions of source code must retain the
      above copyright notice, this list of conditions
      and the following disclaimer.
    * Redistributions in binary form must reproduce
      the above copyright notice, this list of conditions
      and the following disclaimer in the documentation
      and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
'''
import email.parser
import email.policy
import os
import re
import subprocess
import sys
import requests
from urllib.parse import parse_qs, urlparse

# This program gets called with the URL as the argument if we do not
# handle the unsubscribption method ourselves.  You may want something
# like open(1) on macOS or xdg-open(1) on Linux.
URL_HANDLER = 'xdg-open'


def extract_urls(header):
    ''' Given a header value encoded as described in RFC-2369,
    extract any urls and return as a list.
    '''
    url_re = re.compile(r'\s*\<([^>]+)\>,?\s*')

    matches = []
    for match in url_re.finditer(header):
        matches.append(match.group(1))

    return matches


def try_one_click(url, parsed):
    ''' Given the parsed headers object try to perform a one-click
    unsubscribe as described in RFC 8058.  If we cannot for some
    reason return None.  Otherwise return True.
    '''
    # Note this does not check if this meets the DKIM requirements
    # of §4 of the RFC.
    if parsed.get('List-Unsubscribe-Post'):
        body = parsed.get('List-Unsubscribe-Post')
        if body != 'List-Unsubscribe=One-Click':
            print('Invalid one-click header', file=sys.stderr)
            return None

        data = {'List-Unsubscribe': 'One-Click'}
        headers = {'User-Agent': 'mutt-unsubscribe/1.0'}
        try:
            resp = requests.post(url, data=data, headers=headers)
            resp.raise_for_response();
        except Exception as e:
            print(
                f'Exception sending POST to {url}: {e!s}',
                file=sys.stderr
            )
            return None

        print(f'One-Click Result: {resp.content}')
        return True


if __name__ == '__main__':
    msg = email.parser.HeaderParser(policy=email.policy.default)
    parsed = msg.parse(sys.stdin)

    urls = []
    for url in extract_urls(parsed.get('List-Unsubscribe')):
        parts = urlparse(url)
        urls.append((parts.scheme, url))

    types = [x[0] for x in urls]
    # Prefer mailto: unsubscription since it's more likely not to trip
    # my content filters.
    if 'mailto' in types:
        url = [x[1] for x in urls if x[0] == 'mailto'][0]
        subprocess.run(f"{URL_HANDLER} '{url}'", shell=True)

    # If we are doing a https url, check to see if it is one-click
    # and handle it directly if it is.  See RFC-8058
    elif 'https' in types:
        if not try_one_click(url, parsed):
            subprocess.run(f"{URL_HANDLER} '{url}'", shell=True)

    elif 'http' in types:
        subprocess.run(f"{URL_HANDLER} '{url}'", shell=True)

    else:
        print('No supported unsubscription method found')
        for url in urls:
            print(x[1])
