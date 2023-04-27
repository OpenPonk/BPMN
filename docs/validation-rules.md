# OpenPonk BPMN Validation rules
The best from BPMN Method and Style, bpmnlint validation rules

## Sequence Flow
### SF01 (Guaranteed)
A sequence flow must connect to a flow node (activity, gateway, or event) at both ends.

### SF02 (Guaranteed)
A sequence flow may not cross a pool (process) boundary. 

## Message Flow
### MF01 (Guaranteed)
A Message Flow may not connect nodes in the same process (pool). 

## All Nodes
### AN01 (Error)
Class: AN01FlowNodeIncomingFlow

All flow nodes other than Start Events, Boundary Events, and catching Link Events must have an incoming Sequence Flow. 

**Incorrect:**  
<img src="https://user-images.githubusercontent.com/61189344/232329463-1311c5fa-acbd-431d-bebb-1f9e0d94acca.png" height="120px"/>

**Correct:**  
<img src="https://user-images.githubusercontent.com/61189344/232330011-797e189f-52e6-4ddf-be57-1a86c134fa63.png" height="120px"/>


### AN02 (Error)
Class: AN02FlowNodeOutgoingFlow

All flow nodes other than end events and throwing Link events must have an outgoing sequence flow.

**Incorrect:**  
<img src="https://user-images.githubusercontent.com/61189344/234981230-7ea45d5a-8c48-42c7-b359-daf7d2c27ed6.png" height="120px"/>

**Correct:**  
<img src="https://user-images.githubusercontent.com/61189344/232330011-797e189f-52e6-4ddf-be57-1a86c134fa63.png" height="120px"/>

### AN03 (Error)
Class: AN03MaxOneDefaultFlow

Outgoing Default Sequence Flow can have only Exclusive, Inclusive, Complex Gateway or Activity. They can have only one Default Sequence Flow.

**Incorrect:**  
<img src="https://user-images.githubusercontent.com/61189344/234985855-922c0ef7-7273-427b-9f47-8e5704be25a8.png" height="200px"/>

**Correct:**  
<img src="https://user-images.githubusercontent.com/61189344/234986356-3d365506-444d-43cb-b126-c3a4f7675cc0.png" height="200px"/>

### AN04 (Warning)
Class: AN04LabeledMessageFlow

Outgoing Message Flow should be labeled by message name. 

**Incorrect:**  
<img src="https://user-images.githubusercontent.com/61189344/234990776-8c1f8154-d04c-40cf-8522-e6e197f769b5.png" height="200px"/>

**Correct:**  
<img src="https://user-images.githubusercontent.com/61189344/234990993-cd8788db-f132-43f5-8264-c6635d880ffb.png" height="200px"/>

### AN05 (Warning)
Class: AN05LabelValidation

All nodes, except no type Start Event and Parallel Gateway, should be labeled.

**Incorrect:**  
<img src="https://user-images.githubusercontent.com/61189344/234989596-cbdcc7e1-4f23-4133-898c-0e75dfd87970.png" height="200px"/>

**Correct:**  
<img src="https://user-images.githubusercontent.com/61189344/234989876-1f5f343a-c940-4e78-9ef3-093b8499424c.png" height="200px"/>


### AN06 (Error)
A Conditional Sequence Slow may not be used if it is the only outgoing Sequence Flow

## Start Event
### SE01
### SE02
### SE03
### SE04
### SE05
### SE06
## End Event
### EE01
### EE02
### EE03
### EE04
## Boundary Event
### BE01
### BE02
### BE03
### BE04
### BE05
## Intermediate Event
### IE01
### IE02
### IE03
### IE04
## Gateway
### GW01
### GW02
### GW03
### GW04
### GW05
### GW06
### GW07
## Activity
### AC01
### AC02
### AC03
### AC04
### AC05
## Process (Pool)
### PR01
### PR02
### PR03
### PR04
### PR05
### PR06
### PR07
