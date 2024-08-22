


# Networking

# TCP (Transmission Control Protocol) - 4th Layer in OSI Model

## Overview
[TCP and the THREE-WAY Handshake Explained](https://www.youtube.com/watch?v=wMc0H22nyA4)

**Function**: TCP ensures reliable, ordered, and error-checked delivery of data between applications over a network. It is crucial for applications where data integrity and order are essential.

## Common Uses
- **Email**: Guarantees the complete and accurate delivery of messages.
- **File Sharing**: Manages file transfers by establishing a connection and ensuring the integrity of the files being transferred.
- **Downloading**: Ensures that files downloaded are complete and correctly ordered.

TCP - 12 simple ideas to explain the Transmission Control Protocol
https://www.youtube.com/watch?v=JFch3ctY6nE

-> Sequence Numbers track what is sent 
-> Acknowledge Numbers track what is received 

Bob sent (SEQ=101)
Alice sent (ACK=102)

Bob sent (SEQ=102)
Alice sent (ACK=103)

## Sequence Numbers
- **Range**: 0 to 65535
- **Purpose**: Sequence numbers are used to keep track of packets in a TCP connection. Each packet is assigned a unique sequence number which helps in:
  - **Tracking**: Ensuring that all packets are received and in the correct order.
  - **Retransmission**: If a packet (e.g., packet 101) is not received, the server requests a retransmission of the missing packet.

## TCP Deep Dive

### Windowing
- **Concept**: Windowing is used to manage the flow of data between sender and receiver. It involves negotiating a "window size" that determines the number of packets that can be sent before requiring an acknowledgment.
- **Window Size**: Initially set to 2 bytes (or other sizes depending on configuration). The window size adjusts dynamically based on network conditions and receiver's capacity:
  - **Increasing Window Size**: Allows sending more data in one go, improving throughput.
  - **Window Size 0**: Indicates that the receiver is overloaded and cannot handle more data at the moment. The sender must wait until the window size increases before sending more data.

### Error Detection
- **Mechanism**: TCP uses checksums to ensure data integrity. Each packet includes a checksum value calculated based on the packet's contents. The receiver recalculates the checksum and verifies it against the transmitted value to detect any errors.
- **Retransmission**: If a packet's checksum does not match, the packet is retransmitted to ensure correct data delivery.

## Checksum (Layers 2 & 4)
A checksum is a mathematical formula used to verify the integrity of data during transmission.

- **Purpose**: To detect errors in data transmission and ensure that the data received is exactly what was sent.
- **Example Method**:
  1. **Document a Text**: For example, count specific characters like 'E' in a document.
  2. **List the Count**: Note the total count of 'E's on the back of the document.
  3. **Verification**: At the receiving end, if the count of 'E's matches the listed value, the document is considered unmodified. Any discrepancies indicate potential data corruption.

## What Is a Three-Way Handshake in TCP?
The three-way handshake is a fundamental process for establishing a TCP connection. It involves three steps:
1. **SYN**: The client sends a synchronization request to the server.
2. **SYN-ACK**: The server acknowledges the client's request and sends a synchronization acknowledgment.
3. **ACK**: The client acknowledges the server's response, and the TCP connection is established.

For more information, watch the video: [Cisco Systems - Three-Way Handshake](https://www.youtube.com/watch?v=LyDqA-dAPW4&t=184s).

## UDP (User Datagram Protocol)
- **Function**: Offers a faster, connectionless communication method without error recovery.
- **Common Uses**:
  - **Voice over IP (VoIP)**: Enables real-time voice communication over the internet.
  - **Voice and Video Calls**: Provides low-latency communication for calls and video streaming.

### UDP Header (DATA)
- **16-Bit Source Port**: Identifies the sending port.
- **16-Bit Destination Port**: Identifies the receiving port.
- **16-Bit UDP Length**: Indicates the length of the UDP header and data.
- **16-Bit UDP Checksum**: Ensures data integrity by checking for errors in the UDP packet.

## TCP & UDP: Comparing Transport Protocols
For an in-depth comparison of TCP and UDP, including their advantages and disadvantages, refer to this video: [TCP vs UDP](https://www.youtube.com/watch?v=MMDhvHYAF7E).

# OSI Model
[OSI and TCP IP Models](https://www.youtube.com/watch?v=3b_TAYtzuho)

## Overview
The OSI (Open Systems Interconnection) Model is a conceptual framework used to understand and design network protocols. It divides network communication into seven layers, each with specific functions, ensuring standardized interactions between network devices and protocols.

```plaintext
# Video Notes

- OSI model is a reference, guidelines
- Encapsulation (going down in stack, critical for communication), Decapsulation (moving up from Layer 1 to Layer 7)
----------------------------------------------
            Layer 5 to 7, first three layers are accomplished under the application layer
----------------------------------------------
Layer 7: Application      # identify 0's and 1's by a file extension e.g, .exe (0's and 1's), .jpeg (0's and 1's to display a picture/color)
Layer 6: Presentation     # PDU Format (protocol data unit)
Layer 5: Session          # Data Streams, Data 10010101000011 (really trivial, dont its email, voice, phone, internet, tv)
----------------------------------------------

Layer 4: Transport        # identification in networking, application or service, what application is making request, what service recives it, port addressing
                          # source / destination, PDU for transport layer is called segments
                          # TCP, sacrifice time over reliability
                          # pass the segments to network layer called packet
                          # layer 5,6,7 and layer 4 produces segments
                          # Segments, TCP/UDP


Layer 3: Network          # IP, packets, the packet is passed down to data link layer called a frame

----------------------------------------------
Network Access Layer
----------------------------------------------
Layer 2: Data Link        # Frames, MAC -> Ethernet, source/dest addresses (interface card)
Layer 1: Physical         # Bits -> Signals
```

## Layer Breakdown
----------------------------------------------
**Layers 5 to 7**: The first three layers (5 to 7) are often grouped under the Application Layer.

----------------------------------------------
**Layer 7: Application**  
- **Function**: Interfaces directly with end-user applications.  
- **Examples**: Identifies 0's and 1's by file extensions such as `.exe# (for executables) or `.jpeg# (for images).  
- **Purpose**: Handles data that applications understand and use.  

**Layer 6: Presentation**  
- **Function**: Formats or translates data for the application layer.  
- **PDU**: Protocol Data Unit (e.g., data formatting, encryption).  

**Layer 5: Session**  
- **Function**: Manages sessions and connections between applications.  
- **Example Data**: Trivial data representation like `10010101000011# (handles email, voice, internet, etc.).  

----------------------------------------------
**Layer 4: Transport**  
- **Function**: Ensures reliable data transfer between applications and services.  
- **Identification**: Identifies which application is making a request and which service receives it.  
- **PDU**: Segments (e.g., TCP/UDP segments).  
- **Details**: 
  - **TCP**: Sacrifices time for reliability.
  - **UDP**: Faster, less reliable.
  - **Passes Segments**: Segments are passed to the Network Layer as packets.
  - **Interaction**: Layers 5, 6, 7, and Layer 4 produce segments.  

**Layer 3: Network**  
- **Function**: Handles logical addressing and routing of packets.  
- **PDU**: Packets.  
- **Details**: 
  - **IP**: Manages routing and addressing.
  - **Passes Packets**: Packets are passed down to the Data Link Layer as frames.  

----------------------------------------------
**Network Access Layer**  
- **Layer 2: Data Link**  
  - **Function**: Manages node-to-node data transfer and handles error detection and correction.  
  - **PDU**: Frames.  
  - **Examples**: Ethernet, source/destination MAC addresses.  

- **Layer 1: Physical**  
  - **Function**: Transmits raw bit streams over physical media.  
  - **PDU**: Bits.  
  - **Details**: Converts frames into signals for transmission.

## Data Flow and Encapsulation

1. **Sending Data**:
   - **Application Layer**: Data is prepared (e.g., `.jpeg# image).
   - **Presentation Layer**: Data is formatted or encrypted.
   - **Session Layer**: Session management is applied.
   - **Transport Layer**: Data is segmented and TCP headers are added.
   - **Network Layer**: Segments are encapsulated into packets with IP headers.
   - **Data Link Layer**: Packets are encapsulated into frames with MAC addresses.
   - **Physical Layer**: Frames are converted into bits and transmitted.

2. **Receiving Data**:
   - **Physical Layer**: Bits are received and converted into frames.
   - **Data Link Layer**: Frames are decapsulated into packets.
   - **Network Layer**: Packets are decapsulated into segments.
   - **Transport Layer**: Segments are reassembled.
   - **Session Layer**: Session data is processed.
   - **Presentation Layer**: Data is formatted or decrypted.
   - **Application Layer**: File is reconstructed and used by the application.
## Common Interview Questions

1. **What is the OSI Model and why is it important?**
   - The OSI Model is a conceptual framework used to understand and design network protocols. It divides network communication into seven layers, each with specific functions, helping to standardize interactions between network devices and protocols.

2. **How does encapsulation work in the OSI Model?**
   - Encapsulation involves adding protocol information to data as it moves down the OSI layers. Each layer adds its own header or trailer, wrapping the data until it reaches the physical layer as bits.

3. **What are the functions of the Application Layer (Layer 7)?**
   - The Application Layer interfaces directly with end-user applications, providing services such as file transfers, email, and web browsing. It ensures that data is formatted in a way that applications can understand.

4. **What is the difference between TCP and UDP?**
   - TCP (Transmission Control Protocol) is a connection-oriented protocol that provides reliable, ordered, and error-checked delivery of data. UDP (User Datagram Protocol) is connectionless and offers faster transmission without guaranteed delivery.

5. **Explain the role of the Network Layer (Layer 3).**
   - The Network Layer is responsible for logical addressing and routing of packets across networks. It determines the best path for data to travel from source to destination using IP addresses.

6. **What does the Data Link Layer (Layer 2) do?**
   - The Data Link Layer manages node-to-node data transfer and ensures error detection and correction. It formats data into frames and handles MAC addresses for proper delivery within a local network segment.

7. **Describe the Physical Layer (Layer 1).**
   - The Physical Layer transmits raw bit streams over physical media. It deals with the hardware aspects of data transmission, such as cables, switches, and signals.
