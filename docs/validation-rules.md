# OpenPonk BPMN Validation rules
The best from BPMN Method and Style, bpmnlint validation rules

## Sequence Flow
### SF01 (Guaranteed)
Sequence Flow must connect to a flow node (activity, gateway, or event) at both ends.

### SF02 (Guaranteed)
Sequence Flow may not cross a pool (process) boundary. 

## Message Flow
### MF01 (Guaranteed)
Message Flow may not connect nodes in the same process (pool). 

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
A Conditional Sequence Flow may not be used if it is the only outgoing Sequence Flow

**Incorrect:**  
<img src="https://user-images.githubusercontent.com/61189344/235211929-e5a1ad05-0d50-4056-b46e-83631c7ecf44.png" height="120px"/>

**Correct:**  
But you get Warning from the rule AC05.
<img src="https://user-images.githubusercontent.com/61189344/235212295-598c7c5c-aa81-4ad8-8949-14d86da6869a.png" height="200px"/>

## Start Event
### SE01 (Guaranteed)
Start Event must not have an incoming Sequence Flow.

### SE02 (Guaranteed)
Start Event must not have an outgoing Message Flow. 

### SE03 (Error)
Start Event of type Message must have incoming Message Flow.

**Incorrect:**  
<img src="https://user-images.githubusercontent.com/61189344/235220138-fa124ec2-d9de-403a-8d9c-c426e4d99ddc.png" height="120px"/>

**Correct:**  
<img src="https://user-images.githubusercontent.com/61189344/235218507-c0711acb-5c77-4185-9b54-d6f60f9f9f4c.png" height="120px"/>

### SE04 (Error)
Start Event with the incoming Message Flow must be of Message or Multiple type.

**Incorrect:**  
<img src="https://user-images.githubusercontent.com/61189344/235218663-0ebbfbd7-0308-48ae-9bef-3c44c771a9e2.png" height="120px"/>

**Correct:**  
<img src="https://user-images.githubusercontent.com/61189344/235218507-c0711acb-5c77-4185-9b54-d6f60f9f9f4c.png" height="120px"/>

### SE05 (Error)
Start Event may not have an Error trigger. Except Event Subprocess Start Event. 
**Incorrect:**  
<img src="https://user-images.githubusercontent.com/61189344/235218901-9eeef02d-1eb8-4b53-bf44-6e356fb17af7.png" height="120px"/>

**Correct:**  
<img src="https://user-images.githubusercontent.com/61189344/235219357-a9a56008-b239-4944-b205-57758b2931d6.png" height="200px"/>

### SE06 (Error) - Not implemented yet.
Start Event in a Subprocess must not have a type unless it is triggered based on some Event from parent process

## End Event
### EE01 (Guaranteed)
End Event must not have an outgoing Sequence Flow.


### EE02 (Guaranteed)
End Event must not have an incoming Message Flow. 

### EE03 (Error)
End Event of type Message must have outgoing Message Flow.

**Incorrect:**  
<img src="https://user-images.githubusercontent.com/61189344/235220423-39269ea7-fd83-411c-b98e-0b246d299954.png" height="120px"/>

**Correct:**  
<img src="https://user-images.githubusercontent.com/61189344/235220676-5ff21a18-7e67-43cd-ab6b-efd7248af701.png" height="120px"/>

### EE04 (Error)
End Event with the outgoing Message Flow must be of Message or Multiple type.

**Incorrect:**  
<img src="https://user-images.githubusercontent.com/61189344/235221012-fc9eca7b-736b-49ee-af67-feeb36072f8d.png" height="120px"/>

**Correct:**  
<img src="https://user-images.githubusercontent.com/61189344/235220676-5ff21a18-7e67-43cd-ab6b-efd7248af701.png" height="120px"/>

## Boundary Event
### BE01 (Guaranteed)
Boundary Event must not have an incoming Sequence Flow.

### BE02 (Error)
Boundary Event must not have exactly one outgoing Sequence Flow. Except Compensation Boundary Event.
**Incorrect:**  
<img src="https://user-images.githubusercontent.com/61189344/235221417-4cf382b9-2630-4c79-8564-11b335cc05d5.png" height="200px"/>

**Correct:**  
<img src="https://user-images.githubusercontent.com/61189344/235221639-5037a8f1-6474-423f-a4a6-08e0295336d8.png" height="200px"/>

### BE03 (Warning)
Error Boundary Event must contain a corresponding Error Throw Event in the Subprocess. 

**Incorrect:**  
<img src="https://user-images.githubusercontent.com/61189344/235221866-e615e443-e143-422d-a674-f1664fd596e0.png" height="200px"/>

**Correct:**  
<img src="https://user-images.githubusercontent.com/61189344/235222166-0db80ee0-2157-40f1-b335-d53de6d8350f.png" height="200px"/>

### BE04 (Warning)
Escalation Boundary Event must contain a corresponding Escalation Throw Event in the Subprocess. 

**Incorrect:**  
<img src="https://user-images.githubusercontent.com/61189344/235222338-0d887665-e787-4e4e-8cab-e3f0a0e32e87.png" height="200px"/>

**Correct:**  
<img src="https://user-images.githubusercontent.com/61189344/235222540-a09fc3aa-fab5-4632-b064-d927f354b040.png" height="200px"/>

### BE05 (Error)
Error Boundary Event may not be Non-Interrupting.

**Incorrect:**  
<img src="https://user-images.githubusercontent.com/61189344/235222673-40501c46-8f38-41e2-b8ae-bbe820d0ff6d.png" height="120px"/>

**Correct:**  
<img src="https://user-images.githubusercontent.com/61189344/235222789-188eb07c-9e00-417b-91ac-d6d011fa21a8.png" height="120px"/>

## Intermediate Event
### IE01 (Error)
Intermediate Event of type Message Receive must have incoming Message Flow.

### IE02 (Error)
Intermediate Event of type Message Send must have outgoing Message Flow.

### IE03 (Error)
Intermediate Event with the incoming Message Flow must be of Message Receive or Multiple type.

### IE04 (Error)
Intermediate Event with the outgoing Message Flow must be of Message Send or Multiple type.

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
