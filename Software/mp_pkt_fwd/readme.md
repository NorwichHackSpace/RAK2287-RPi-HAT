	 / _____)             _              | |    
	( (____  _____ ____ _| |_ _____  ____| |__  
	 \____ \| ___ |    (_   _) ___ |/ ___)  _ \ 
	 _____) ) ____| | | || |_| ____( (___| | | |
	(______/|_____)_|_|_| \__)_____)\____)_| |_|
	  (C)2013 Semtech-Cycleo
	  (C)2015 Modfications by Ruud Vlaming (The Things Network)
	  (C)2017 Modification by Jac Kersing

Lora Gateway packet forwarder with multiple extensions
======================================================

1. Introduction
----------------

The multi protocol  packet forwarder is a program running on the host 
of a Lora Gateway that forward RF packets received by the concentrator 
to a server through a IP/UDP or IP/TCP link, and emits RF packets that 
are sent by the server.

It allows for the injection of virtual radio packets for testing and
is capable of communication with multiple servers. It is based on the
beacon_packet_forwarder with the distinction that the operator has
detailed control over all capabilities. So beacon, gps, injection,
up/down stream, all can be (de)activated by modifying the json config file.

To learn more about the IP/UDP network protocol between the gateway and the server, 
please read the PROTOCOL.TXT document.
For the IP/TCP (MQTT) network protocol please consult the information available at
https://github.com/TheThingsNetwork/ttn-gateway-connector

2. System schematic and definitions
------------------------------------
                                      
         ((( Y ))) 
             |                                   
             |     
         +- -|- - - - - - - - - - - - -+          xxxxxxxx             +---------+
         |+--+-----------+     +------+|       xxx        xxx          |         |-+
         ||              |     |      ||      xx  Internet  xx         |         | |-+
         || Concentrator |<----+ Host |<---- xx      or      xx ======>| Network | | |-+
         ||              | SPI |      ||      xx  Intranet  xx         | Servers | | | |
         |+--------------+     +------+|       xxx        xxx          |         | | | |
         |   ^                    ^    |        | xxxxxxxx |           |         | | | |
         |   | PPS  +-----+  NMEA |    |        |          |           |         | | | |
         |   +------| GPS |-------+    |  +--------+  +---------+      +---------+ | | |
         |          +-----+            |  | ghost  |  | monitor |        +---------+ | |
         |                             |  | server |  | server  |          +---------+ |
         |            Gateway          |  +--------+  +---------+            +---------+
         +- - - - - - - - - - - - - - -+

Concentrator: radio RX/TX board, based on Semtech multichannel modems (SX130x), 
transceivers (SX135x) and/or low-power stand-alone modems (SX127x).

Host: embedded computer on which the packet forwarder runs. Drives the 
concentrator through an SPI link.

Gateway: a device composed of at least one radio concentrator, a host, some 
network connection to the internet or a private network (Ethernet, 3G, Wifi, 
microwave link), and optionally a GPS receiver for synchronization. 

Network Servers: abstract computers that will process the RF packets received and 
forwarded by the gateway, and issue RF packets in response that the gateway 
will have to emit.

Ghost Server: Program on the same host or another computer that serves simulated 
radio packets for testing purposes. Packets are sent/received via UDP protocol.

Monitor Server: Program on the same host or another computer from which it is 
possible to maintain the gateway by requesting system status updates or logging 
in by an ssh tunnel through a firewall (on the gateways side)


3. Dependencies
----------------

This program uses the Parson library (http://kgabis.github.com/parson/) by
Krzysztof Gabis for JSON parsing.
Many thanks to him for that very practical and well written library.

This program is statically linked with the libloragw Lora concentrator library.
It was tested with v1.3.0 of the library but should work with any later 
version provided the API is v1 or a later backward-compatible API.
Data structures of the received packets are accessed by name (ie. not at a
binary level) so new functionalities can be added to the API without affecting
the program at all.

This program follows the v1.1 version of the gateway-to-server protocol.

The last dependency is the hardware concentrator (based on FPGA or SX130x 
chips) that must be matched with the proper version of the HAL.

4. Usage
---------

To stop the application, press Ctrl+C.
Unless it is manually stopped or encounter a critical error, the program will 
run forever.

There are no command line launch options.

The way the program takes configuration files into account is the following:
 * if there is a debug_conf.json parse it, others are ignored
 * if there is a global_conf.json parse it, look for the next file
 * if there is a local_conf.json parse it
If some parameters are defined in both global and local configuration files, 
the local definition overwrites the global definition. 

The global configuration file should be exactly the same throughout your 
network, contain all global parameters (parameters for "sensor" radio 
channels) and preferably default "safe" values for parameters that are 
specific for each gateway (eg. specify a default MAC address).

The local configuration file should contain parameters that are specific to 
each gateway (eg. MAC address, frequency for backhaul radio channels).

In each configuration file, the program looks for a JSON object named 
"SX1301_conf" that should contain the parameters for the Lora concentrator 
board (RF channels definition, modem parameters, etc) and another JSON object 
called "gateway_conf" that should contain the gateway parameters (gateway MAC 
address, IP address of the server, keep-alive time, etc).

To learn more about the JSON configuration format, read the provided JSON 
files and the libloragw API documentation.

Every X seconds (parameter settable in the configuration files) the program 
display statistics on the RF packets received and sent, and the network 
datagrams received and sent.
The program also send some statistics to the server in JSON format.

5. License
-----------

Copyright (C) 2013, SEMTECH S.A.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.
* Neither the name of the Semtech corporation nor the
  names of its contributors may be used to endorse or promote products
  derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL SEMTECH S.A. BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

6. License for Parson library
------------------------------

Parson ( http://kgabis.github.com/parson/ )
Copyright (C) 2012 Krzysztof Gabis

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

7. License for the modifications by Jac Kersing
-----------------------------------------------

Copyright (C) 2017 Jac Kersing
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.
* Neither the name of Jac Kersing nor the names of its contributors 
  may be used to endorse or promote products derived from this software 
  without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL JAC KERSING BE LIABLE FOR ANY DIRECT, INDIRECT, 
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, 
OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF 
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF 
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*EOF*
