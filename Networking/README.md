


## Networking 
### What Is a Three-Way Handshake in TCP?
https://www.youtube.com/@CiscoSystems

### TCP: 
syn, ack, syn ack
email
file sharing Downloading

### UDP:
user datagram protocol
voice over ip
voice, video call

### UDP Header (DATA)
16-Bit Source Port, 16-Bit Destination Port
16-Bit UDP Length, 16-Bit UDP Checksum 
### TCP & UDP: Comparing Transport Protocols
https://www.youtube.com/watch?v=MMDhvHYAF7E
![tcp vs udp](Pictures/tcp_vs_udp.png)

### Checksum (Layer 2 & 4)
A quick mathematical formula
Document, count the number of E's, List it on the back, don't tell what it means, if the total number of E's match, the document isn't moified

## OSI Model
[OSI and TCP IP Models](https://www.youtube.com/watch?v=3b_TAYtzuho)

- its a reference, guidelines
- Encapsulation (going down in stack, critical for communication), Decapsulation(moving up from Layer 1 to Layer 7)
```
----------------------------------------------
            Layer 5 to 7, first three layers are accomplished under the application layer
----------------------------------------------
Layer 7: Application      # identify 0's and 1's by a file extension e.g, .exe (0's and 1's), .jpeg (0's and 1's to display a picture/color)
Layer 6: Presentation     # PDU (protocol data unit)
Layer 5: Session          # Data 10010101000011 (really trivial, dont its email, voice, phone, internet, tv)
----------------------------------------------

Layer 4: Transport        # identification in networking, application or service, what application is making request, what service recives it, port addressing
                          # source / destination, PDU for transport layer is called segments
                          # TCP, sacrifice time over reliability
                          # pass the segments to network layer called packet
                          # layer 5,6,7 and layer 4 produces segments


Layer 3: Network          # IP, packet, the packet is passed down to data link layer called a frame

----------------------------------------------
Network Access Layer
----------------------------------------------
Layer 2: Data Link        # (Frame) Ethernet, source/dest addresses (interface card)
Layer 1: Physical         # Bits -> Signals
```
# OSI Model

## Overview

The OSI (Open Systems Interconnection) Model is a conceptual framework used to understand and design network protocols. It divides network communication into seven layers, each with specific functions, ensuring standardized interactions between network devices and protocols.

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

## OSI Model Diagram

```plaintext
  +--------------------------+
  |       Layer 7:           |
  |      Application         |
  |  (e.g., .exe, .jpeg)     |
  +--------------------------+
             |
             | Encapsulation
             |
  +--------------------------+
  |       Layer 6:           |
  |      Presentation        |
  |  (e.g., PDU format)      |
  +--------------------------+
             |
             | Encapsulation
             |
  +--------------------------+
  |       Layer 5:           |
  |        Session           |
  |  (e.g., Data streams)    |
  +--------------------------+
             |
             | Encapsulation
             |
  +--------------------------+
  |       Layer 4:           |
  |      Transport           |
  |  (e.g., Segments, TCP/UDP) |
  +--------------------------+
             |
             | Encapsulation
             |
  +--------------------------+
  |       Layer 3:           |
  |        Network           |
  |  (e.g., Packets, IP)     |
  +--------------------------+
             |
             | Encapsulation
             |
  +--------------------------+
  |       Layer 2:           |
  |       Data Link          |
  |  (e.g., Frames, MAC)     |
  +--------------------------+
             |
             | Encapsulation
             |
  +--------------------------+
  |       Layer 1:           |
  |       Physical           |
  |  (e.g., Bits, Signals)   |
  +--------------------------+

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

Use this document to understand and review the OSI model for networking concepts and prepare for technical interviews or exams.
