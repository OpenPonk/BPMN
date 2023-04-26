Class {
	#name : #OPBPMNXMLWriterVisitorTest,
	#superclass : #TestCase,
	#category : #'OpenPonk-BPMN-Tests'
}

{ #category : #tests }
OPBPMNXMLWriterVisitorTest >> testVisitElement [

	| model writerVisitor |
	model := OPBPMNGatewayModel new.
	model name: 'Test name'.
	writerVisitor := OPBPMNXMLWriterVisitor new.
	writerVisitor visitElementEvent: model.
	self
		assert: writerVisitor writer asString
		equals: '<?xml version="1.0" encoding="UTF-8"?>
<bpmn:exclusiveGateway name="Test name" id="_6-' , model uuid asString
			, '"/>'
]

{ #category : #tests }
OPBPMNXMLWriterVisitorTest >> testVisitElementActivity [
| model writerVisitor|
model := OPBPMNActivityModel new.
model name: 'Test name'.
model type: OPBPMNNodeType Service.
model executableAttribute: 'attribute'.
model executableAttributeValue: 'value'.
writerVisitor := OPBPMNXMLWriterVisitor new.
writerVisitor visitElementActivity: model.
self assert: writerVisitor writer asString equals: 
'<?xml version="1.0" encoding="UTF-8"?>
<bpmn:serviceTask name="Test name" id="_6-', model uuid asString,'" attribute="value"/>'
   
]

{ #category : #tests }
OPBPMNXMLWriterVisitorTest >> testVisitElementEvent [
| model writerVisitor|
model := OPBPMNStartEventModel new.
model name: 'Test name'.
model type: OPBPMNNodeType Timer.
model timerType: 'timeDuration'.
model timerValue: 'PT5M'.
writerVisitor := OPBPMNXMLWriterVisitor new.
writerVisitor visitElementEvent: model.
self assert: writerVisitor writer asString equals: 
'<?xml version="1.0" encoding="UTF-8"?>
<bpmn:startEvent name="Test name" id="_6-', model uuid asString,'">
    <bpmn:timerEventDefinition id="timerEventDefinition_', model uuid asString,'">
        <bpmn:timeDuration xsi:type="semantic:tFormalExpression">PT5M</bpmn:timeDuration>
    </bpmn:timerEventDefinition>
</bpmn:startEvent>'
]

{ #category : #tests }
OPBPMNXMLWriterVisitorTest >> testVisitElementEventTimer [
| model writerVisitor|
model := OPBPMNStartEventModel new.
model name: 'Test name'.
model type: OPBPMNNodeType Timer.
model timerType: 'timeDuration'.
model timerValue: 'PT5M'.
writerVisitor := OPBPMNXMLWriterVisitor new.
writerVisitor visitElementEventTimer: model.
self assert: writerVisitor writer asString equals: 
'<?xml version="1.0" encoding="UTF-8"?>
<bpmn:timerEventDefinition id="timerEventDefinition_', model uuid asString,'">
    <bpmn:timeDuration xsi:type="semantic:tFormalExpression">PT5M</bpmn:timeDuration>
</bpmn:timerEventDefinition>'
]

{ #category : #tests }
OPBPMNXMLWriterVisitorTest >> testVisitFlowRefInOut [
| model writerVisitor modelSource modelTarget |
modelSource := OPBPMNActivityModel new.
modelTarget := OPBPMNActivityModel new.
model := OPBPMNFlowModel new.
model name: 'Test name'.
model source: modelSource.
model target: modelTarget.
writerVisitor := OPBPMNXMLWriterVisitor new.
writerVisitor visitFlowRef: model inOut: 'outgoing'.
self assert: writerVisitor writer asString equals: '<?xml version="1.0" encoding="UTF-8"?>
<bpmn:outgoing>_6-', model uuid asString ,'</bpmn:outgoing>'.

writerVisitor := OPBPMNXMLWriterVisitor new.
writerVisitor visitFlowRef: model inOut: 'incoming'.
self assert: writerVisitor writer asString equals: '<?xml version="1.0" encoding="UTF-8"?>
<bpmn:incoming>_6-', model uuid asString ,'</bpmn:incoming>'
]

{ #category : #tests }
OPBPMNXMLWriterVisitorTest >> testVisitFlowType [
| model writerVisitor modelSource modelTarget |
modelSource := OPBPMNActivityModel new.
modelTarget := OPBPMNActivityModel new.
model := OPBPMNFlowModel new.
model name: 'Test name'.
model source: modelSource.
model target: modelTarget.
writerVisitor := OPBPMNXMLWriterVisitor new.
writerVisitor visitFlow: model type: 'sequenceFlow'.
self assert: writerVisitor writer asString equals: '<?xml version="1.0" encoding="UTF-8"?>
<bpmn:sequenceFlow sourceRef="_6-', modelSource uuid asString ,'" targetRef="_6-', modelTarget uuid asString ,'" name="Test name" id="_6-', model uuid asString, '"/>'
]

{ #category : #tests }
OPBPMNXMLWriterVisitorTest >> testVisitParticipantRef [
| model writerVisitor|
model := OPBPMNPoolModel new.
model name: 'Test name'.
writerVisitor := OPBPMNXMLWriterVisitor new.
writerVisitor visitParticipantRef: model.
self assert: writerVisitor writer asString equals: '<?xml version="1.0" encoding="UTF-8"?>
<bpmn:participant id="participant_', model uuid asString, '" processRef="_6-', model uuid asString, '"/>'
]
