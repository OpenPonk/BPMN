# OpenPonk BPMN Validation rules
The best from BPMN Method and Style, bpmnlint validation rules and Signavio Best Practice.

Severity of rules:

- **Guaranteed** - You are not able to model this.
- **Error** - You should remove the Error because it can cause fatal problems in running process.
- **Warning** - Is better to make it clear but the model is still correct according to BPMN documentation.

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
<img src="https://user-images.githubusercontent.com/61189344/235223618-6b9e79b9-23e4-4114-8dd1-b481c2727780.png" height="200px"/>

**Correct:**  
<img src="https://user-images.githubusercontent.com/61189344/235223694-8bb08391-f226-494f-8148-b34b600957fb.png" height="200px"/>

### BE04 (Warning)
Escalation Boundary Event must contain a corresponding Escalation Throw Event in the Subprocess. 

**Incorrect:**  
<img src="https://user-images.githubusercontent.com/61189344/235223889-166ab7f3-ec69-4b7b-b89f-97b0406b573b.png" height="200px"/>

**Correct:**  
<img src="https://user-images.githubusercontent.com/61189344/235223986-2a197441-5110-4a9a-bc2f-9618384814f5.png" height="200px"/>

### BE05 (Error)
Error Boundary Event may not be Non-Interrupting.

**Incorrect:**  
<img src="https://user-images.githubusercontent.com/61189344/235222673-40501c46-8f38-41e2-b8ae-bbe820d0ff6d.png" height="120px"/>

**Correct:**  
<img src="https://user-images.githubusercontent.com/61189344/235222789-188eb07c-9e00-417b-91ac-d6d011fa21a8.png" height="120px"/>

## Intermediate Event
### IE01 (Error)
Intermediate Event of type Message Receive must have incoming Message Flow.

**Incorrect:**  
<img src="https://user-images.githubusercontent.com/61189344/235224320-96db49df-7c93-4999-9836-2fae9a2b319f.png" height="120px"/>

**Correct:**  
<img src="https://user-images.githubusercontent.com/61189344/235224497-153af81d-4267-443c-b733-5cf2daf5e366.png" height="120px"/>

### IE02 (Error)
Intermediate Event of type Message Send must have outgoing Message Flow.

**Incorrect:**  
<img src="https://user-images.githubusercontent.com/61189344/235224886-323d858d-1436-4906-8427-439f33d69618.png" height="120px"/>

**Correct:**  
<img src="https://user-images.githubusercontent.com/61189344/235225027-8d299959-b2d2-4462-9312-7b37e63c79fc.png" height="120px"/>

### IE03 (Error)
Intermediate Event with the incoming Message Flow must be of Message Receive or Multiple type.

**Incorrect:**  
<img src="https://user-images.githubusercontent.com/61189344/235225455-7104271d-fc0e-4fcc-ae49-89835a0ae5af.png" height="120px"/>

**Correct:**  
<img src="https://user-images.githubusercontent.com/61189344/235224497-153af81d-4267-443c-b733-5cf2daf5e366.png" height="120px"/>

### IE04 (Error)
Intermediate Event with the outgoing Message Flow must be of Message Send or Multiple type.

**Incorrect:**  
<img src="https://user-images.githubusercontent.com/61189344/235225318-27dcf914-c328-4b41-a754-ff037035e716.png" height="120px"/>

**Correct:**  
<img src="https://user-images.githubusercontent.com/61189344/235225027-8d299959-b2d2-4462-9312-7b37e63c79fc.png" height="120px"/>

## Gateway
### GW01 (Guaranteed)
Boundary Event must not have incoming or outgoing Message Flow.

### GW02 (Error)
Splitting Gateway must have more than one outgoing Sequence Flow. Merging Gateway
must have more than one incoming Sequence Flow.

**Incorrect:**  
<img src="https://user-images.githubusercontent.com/61189344/235251173-002c1c54-798f-46bd-ba27-e49eb25e85ca.png" height="120px"/>

**Correct:**  
<img src="https://user-images.githubusercontent.com/61189344/235251617-acc9d74f-87f0-4e40-b3ec-29c52a6a7054.png" height="200px"/>

### GW03 (Warning)
Gateway should not be both merging and spliting.

**Incorrect:**  
<img src="https://user-images.githubusercontent.com/61189344/235251929-49e0fc52-6dbc-4db8-af5b-2a2f8c49713e.png" height="200px"/>

**Correct:**  
<img src="https://user-images.githubusercontent.com/61189344/235252167-3e55d9f0-08b0-4f46-af13-86473015cc2e.png" height="200px"/>

### GW04 (Error)
Event Gateway can only contain Catching Intermediate Event or Receive Task in its branches.

**Incorrect:**  
<img src="https://user-images.githubusercontent.com/61189344/235252702-269ebdc5-9e6a-4597-ae21-43e1aa0abb84.png" height="200px"/>

**Correct:**  
<img src="https://user-images.githubusercontent.com/61189344/235254484-6fa4d601-cf3e-4af3-8111-1a7f501fbd70.png" height="200px"/>

### GW05 (Error)
Sequence Flow leading from Parallel/Event Gateway must not contain condition. (Label)

**Incorrect:**  
<img src="https://user-images.githubusercontent.com/61189344/235254788-ea490825-d42e-49ba-9ce6-dfdf82058aa7.png" height="200px"/>

**Correct:**  
<img src="https://user-images.githubusercontent.com/61189344/235254484-6fa4d601-cf3e-4af3-8111-1a7f501fbd70.png" height="200px"/>

### GW06 (Error)
Sequence Flow leading from Gateway must not be of conditional type. (Diamont at the beggining of Flow)

**Incorrect:**  
<img src="https://user-images.githubusercontent.com/61189344/235255003-c3c07faa-89a5-47ba-ada4-336a75f5ecf0.png" height="200px"/>

**Correct:**  
<img src="https://user-images.githubusercontent.com/61189344/235255133-18993565-9ebd-44dc-84f8-777e1382ae5a.png" height="200px"/>

### GW07 (Warning)
Sequence Flow leading from Gateway (of a different type than Parallel and Event and beyond
default edges) should be labeled.

**Incorrect:**  
<img src="https://user-images.githubusercontent.com/61189344/235255305-281ad76c-397c-48aa-be0c-bab2de07f290.png" height="200px"/>

**Correct:**  
<img src="https://user-images.githubusercontent.com/61189344/235255133-18993565-9ebd-44dc-84f8-777e1382ae5a.png" height="200px"/>

## Activity
### AC01 (Error)
Activity of type Message Receive must have incoming Message Flow.

**Incorrect:**  
<img src="https://user-images.githubusercontent.com/61189344/235226708-a242a02e-74c3-47aa-99a3-e8a5c09084c6.png" height="120px"/>

**Correct:**  
<img src="https://user-images.githubusercontent.com/61189344/235226812-9dfff399-d541-4c00-a5e6-9034bfdcfd22.png" height="120px"/>

### AC02 (Error)
Activity of type Message Send must have outgoing Message Flow.

**Incorrect:**  
<img src="https://user-images.githubusercontent.com/61189344/235227251-c3891446-dc42-414f-960c-2663e512fdfc.png" height="120px"/>

**Correct:**  
<img src="https://user-images.githubusercontent.com/61189344/235227451-b35b0c77-22d8-46eb-8354-5c7049892e10.png" height="120px"/>

### AC03 (Error)
Activity with the incoming Message Flow must be of Message Receive type.

**Incorrect:**  
<img src="https://user-images.githubusercontent.com/61189344/235227006-ecb769d2-ee9e-4c9a-bdfb-24f18b12c79b.png" height="120px"/>

**Correct:**  
<img src="https://user-images.githubusercontent.com/61189344/235226812-9dfff399-d541-4c00-a5e6-9034bfdcfd22.png" height="120px"/>

### AC04 (Error)
Activity with the outgoing Message Flow must be of Message Send type.

**Incorrect:**  
<img src="https://user-images.githubusercontent.com/61189344/235227780-b1c973f4-069d-4226-89ff-d30110786186.png" height="120px"/>

**Correct:**  
<img src="https://user-images.githubusercontent.com/61189344/235227451-b35b0c77-22d8-46eb-8354-5c7049892e10.png" height="120px"/>

### AC05 (Warning)
Activity should not be used to merge or split flow.

**Incorrect:**  
<img src="https://user-images.githubusercontent.com/61189344/235212295-598c7c5c-aa81-4ad8-8949-14d86da6869a.png" height="200px"/>

**Correct:**  
<img src="https://user-images.githubusercontent.com/61189344/235228863-aa463f88-8db8-4b86-8972-a8d8a43f546d.png" height="200px"/>

## Process (Pool)
### PR01 (Guaranteed)
Pool cannot contain another Pool.

### PR02 (Error)
Process must have at least one Activity.

**Incorrect:**  
<img src="https://user-images.githubusercontent.com/61189344/235256937-9d71dc19-bde1-4b45-9e61-92c24637e519.png" height="120px"/>

**Correct:**  
<img src="https://user-images.githubusercontent.com/61189344/232330011-797e189f-52e6-4ddf-be57-1a86c134fa63.png" height="120px"/>

### PR03 (Error)
Elements of at most one process can be contained only in one Pool.
- You can get only one of PR03 and PR04 errors. - You get PR03 error if there is some Activity outside of Pool.
**Incorrect:**  
<img src="https://user-images.githubusercontent.com/61189344/235257272-46b4e59f-aa4a-450e-ac42-224478230a48.png" height="220px"/>

**Correct:**  
<img src="https://user-images.githubusercontent.com/61189344/235257483-10ee4245-defe-4fc1-8b41-cb19d2191e06.png" height="220px"/>

### PR04 (Error)
If the diagram contains only one participant, it does not have to be drawn. 
If there is more, all elements must be drawn inside Pools.
- You can get only one of PR03 and PR04 errors. 
**Incorrect:**  
<img src="https://user-images.githubusercontent.com/61189344/235257806-106bde50-94c9-4f9a-926a-8fcdb94b3e21.png" height="220px"/>

**Correct:**  
<img src="https://user-images.githubusercontent.com/61189344/235257973-687f5200-812b-4d12-a7f0-9814eb3bb78b.png" height="220px"/>

### PR05 (Error)
Pool can be source of a Message Flow only as a Black-Box. - Cannot contain elements.

**Same as PR06**  

### PR06 (Error)
Pool can be target of a Message Flow only as a Black-Box. - Cannot contain elements. 
Otherwise use Activity/Event as target.

**Incorrect:**  
<img src="https://user-images.githubusercontent.com/61189344/235258664-53bf8d44-467b-47d7-adc0-0041fc3b0915.png" height="220px"/>

**Correct:**  
<img src="https://user-images.githubusercontent.com/61189344/235258936-d46977c5-a9f6-4bf5-b038-14140f5b28ef.png" height="220px"/>

### PR07 (Warning)
Process should contain Start and End Event.

**Mostly you get AN01 or AN02 Error to this.**
