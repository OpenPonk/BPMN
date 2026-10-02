"
I am a unit test class verifying the correct serialization and conversion of BPMN model elements (activities, flows, participants, events) into XML format by the visitor.
"
Class {
	#name : 'OPBPMNXMLWriterVisitorTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testActivityIncomingContainsOnlySequenceFlows [
	| activity sourceActivity sequenceFlow annotation association visitor xml |
	activity := OPBPMNActivityModel new.
	activity name: 'Check Stock'.

	sourceActivity := OPBPMNActivityModel new.
	sourceActivity name: 'Order Placed'.

	sequenceFlow := OPBPMNFlowModel new.
	sequenceFlow source: sourceActivity.
	sequenceFlow target: activity.
	(activity flows ifNil: [ activity instVarNamed: #flows put: OrderedCollection new ]) add: sequenceFlow.

	annotation := OPBPMNAnnotationModel new.
	annotation text: 'SLA Note'.

	association := OPBPMNAssociationModel new.
	association source: annotation.
	association target: activity.
	activity flows add: association.

	visitor := OPBPMNXMLWriterVisitor new.
	visitor visitElementActivity: activity.
	xml := visitor writer asString.

	self assert: (xml includesSubstring: '<bpmn:incoming>' , sequenceFlow printIdType , sequenceFlow uuid asString , '</bpmn:incoming>').
	self deny: (xml includesSubstring: '<bpmn:incoming>' , association printIdType , association uuid asString , '</bpmn:incoming>')
		description: 'Associations must not be exported as <incoming> flow references'
]

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testBoundaryEventExportsAttachedToRef [
	| subProcess boundaryEvent visitor xml |
	subProcess := OPBPMNSubProcessModel new.
	subProcess name: 'Procure Items'.

	boundaryEvent := OPBPMNBoundaryEventModel new.
	boundaryEvent name: '2 Days SLA'.
	boundaryEvent instVarNamed: #owner put: subProcess.

	visitor := OPBPMNXMLWriterVisitor new.
	visitor visitElement: boundaryEvent.
	xml := visitor writer asString.

	self assert: (xml includesSubstring: '<bpmn:boundaryEvent').
	self assert: (xml includesSubstring: 'attachedToRef="' , subProcess printIdType , subProcess uuid asString , '"')
		description: 'Boundary event must declare attachedToRef attribute pointing to its owner'
]

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testBoundaryEventModelPrintTypeIsBoundaryEvent [
	self assert: OPBPMNBoundaryEventModel new printType equals: 'boundaryEvent'
]

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testExportAnnotationDoesNotCrashOnPrintType [
	| annotation visitor xmlContent |
	annotation := OPBPMNAnnotationModel new.
	annotation text: 'Implementation notes'.

	visitor := OPBPMNXMLWriterVisitor new.
	visitor visitElement: annotation.
	xmlContent := visitor contents.

	self assert: (xmlContent includesSubstring: 'textAnnotation').
	self assert: (xmlContent includesSubstring: 'Implementation notes')
]

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testExportAssociationDoesNotCrashOnPrintIdType [
	| task annotation association visitor xmlContent |
	task := OPBPMNActivityModel new.
	task name: 'Write Code'.

	annotation := OPBPMNAnnotationModel new.
	annotation text: 'Implementation notes'.

	association := OPBPMNAssociationModel new.
	association source: task.
	association target: annotation.

	visitor := OPBPMNXMLWriterVisitor new.
	visitor visitElement: association.
	xmlContent := visitor contents.

	self assert: (xmlContent includesSubstring: 'association').
	self assert: (xmlContent includesSubstring: task uuid asString).
	self assert: (xmlContent includesSubstring: annotation uuid asString)
]

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testExportBoundaryEventWithTimerDoesNotCrashOnTimerType [
	| boundaryEvent visitor xml |
	boundaryEvent := OPBPMNBoundaryEventModel new.
	boundaryEvent name: '2 Days SLA'.
	boundaryEvent type: OPBPMNNodeType Timer.

	visitor := OPBPMNXMLWriterVisitor new.
	visitor visitElementBoundaryEvent: boundaryEvent.
	xml := visitor writer asString.

	self assert: (xml includesSubstring: '<bpmn:boundaryEvent').
	self assert: (xml includesSubstring: '<bpmn:timerEventDefinition')
		description: 'Timer boundary event must emit timerEventDefinition'
]

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testExportCollapsedSubProcessCallActivity [
	| subProcess visitor xmlContent |
	subProcess := OPBPMNCollapsedSubProcessModel new.
	subProcess name: 'External Service'.
	subProcess isCallActivity: true.

	visitor := OPBPMNXMLWriterVisitor new.
	visitor visitElement: subProcess.
	xmlContent := visitor contents.

	self assert: (xmlContent includesSubstring: 'External Service').
	self assert: (xmlContent includesSubstring: 'callActivity')
]

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testExportCollapsedSubProcessDoesNotCrash [
	| subProcess visitor xmlContent |
	subProcess := OPBPMNCollapsedSubProcessModel new.
	subProcess name: 'Order Processing'.

	visitor := OPBPMNXMLWriterVisitor new.
	visitor visitElement: subProcess.
	xmlContent := visitor contents.

	self assert: (xmlContent includesSubstring: 'Order Processing').
	self assert: (xmlContent includesSubstring: 'subProcess')
]

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testExportExampleOrderFulfillmentSucceedsAndIsWellFormed [
	| model xml |
	model := OPBPMNExamples exampleOrderFulfillment.
	xml := OPBPMNXMLWriter toString: model.

	self assert: (xml includesSubstring: '<bpmn:definitions').
	self assert: (xml includesSubstring: 'targetNamespace="https://openponk.org/"').
	XMLDOMParser parse: xml
]

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testExportPoolWithLanesExportsAnnotationsAndDataObjects [
	| pool lane activity annotation dataObject visitor xml |
	pool := OPBPMNPoolModel new.
	pool name: 'Order Fulfillment'.
	lane := OPBPMNLaneModel new.
	lane name: 'Sales'.
	pool add: lane.

	activity := OPBPMNActivityModel new.
	activity name: 'Check Stock'.
	lane add: activity.

	annotation := OPBPMNAnnotationModel new.
	annotation text: 'SLA 48 hours'.
	lane add: annotation.

	dataObject := OPBPMNDataObjectModel new.
	dataObject name: 'Order Details'.
	lane add: dataObject.

	visitor := OPBPMNXMLWriterVisitor new.
	visitor visitElement: pool.
	xml := visitor writer asString.

	self assert: (xml includesSubstring: '<bpmn:textAnnotation')
		description: 'Lane textAnnotation must be exported into process body'.
	self assert: (xml includesSubstring: '<bpmn:dataObject')
		description: 'Lane dataObject must be exported into process body'
]

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testExportPoolWithLanesExportsAssociations [
	| pool lane activity annotation association visitor xml |
	pool := OPBPMNPoolModel new.
	pool name: 'Order Fulfillment'.
	lane := OPBPMNLaneModel new.
	lane name: 'Sales'.
	pool add: lane.

	activity := OPBPMNActivityModel new.
	activity name: 'Check Stock'.
	lane add: activity.

	annotation := OPBPMNAnnotationModel new.
	annotation text: 'SLA Note'.
	lane add: annotation.

	association := OPBPMNAssociationModel new.
	association source: annotation.
	association target: activity.
	(activity flows ifNil: [ activity instVarNamed: #flows put: OrderedCollection new ]) add: association.
	(annotation associations ifNil: [ annotation instVarNamed: #associations put: OrderedCollection new ]) add: association.

	visitor := OPBPMNXMLWriterVisitor new.
	visitor visitElement: pool.
	xml := visitor writer asString.

	self assert: (xml includesSubstring: '<bpmn:association')
		description: 'Process must export associations connected to its elements'
]

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testExportPoolWithLanesExportsDataFlowAsAssociationOrDataAssociation [
	| pool lane task dataObject dataFlow visitor xml |
	pool := OPBPMNPoolModel new.
	pool name: 'Order Fulfillment'.

	lane := OPBPMNLaneModel new.
	lane name: 'Sales'.
	pool addLane: lane.

	task := OPBPMNActivityModel new.
	task name: 'Check Stock'.
	lane add: task.

	dataObject := OPBPMNDataObjectModel new.
	dataObject name: 'Order Details'.
	lane add: dataObject.

	dataFlow := (OPBPMNDataFlowModel from: dataObject to: task)
		name: 'Order Info';
		yourself.
	dataObject addFlow: dataFlow.
	task addFlow: dataFlow.

	visitor := OPBPMNXMLWriterVisitor new.
	visitor visitElement: pool.
	xml := visitor writer asString.

	self assert: (xml includesSubstring: dataFlow printIdType , dataFlow uuid asString)
		description: 'DataFlow ID must be present in semantic XML body (as association or dataInputAssociation)'
]

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testExportSubProcessExportsContainedNodesAndSequenceFlows [
	| subProcess startTask endTask flow visitor xml |
	subProcess := OPBPMNSubProcessModel new.
	subProcess name: 'Procure Items'.

	startTask := OPBPMNActivityModel new.
	startTask name: 'Check Suppliers'.
	subProcess add: startTask.

	endTask := OPBPMNEndEventModel new.
	endTask name: 'Items Procured'.
	subProcess add: endTask.

	flow := OPBPMNFlowModel new.
	flow source: startTask.
	flow target: endTask.
	subProcess add: flow.

	visitor := OPBPMNXMLWriterVisitor new.
	visitor visitElement: subProcess.
	xml := visitor writer asString.

	self assert: (xml includesSubstring: 'Check Suppliers')
		description: 'Inner task must be exported inside subProcess'.
	self assert: (xml includesSubstring: 'Items Procured')
		description: 'Inner end event must be exported inside subProcess'.
	self assert: (xml includesSubstring: '<bpmn:sequenceFlow')
		description: 'Inner sequence flow must be exported inside subProcess'
]

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testPoolProcessDoesNotContainIncomingOrOutgoing [
	| pool flow activity visitor xml |
	pool := OPBPMNPoolModel new.
	pool name: 'Customer'.

	activity := OPBPMNActivityModel new.
	activity name: 'Order Placed'.

	flow := OPBPMNMessageFlowModel new.
	flow source: pool.
	flow target: activity.
	(pool flows ifNil: [ pool instVarNamed: #flows put: OrderedCollection new ]) add: flow.

	visitor := OPBPMNXMLWriterVisitor new.
	visitor visitElement: pool.
	xml := visitor writer asString.

	self deny: (xml includesSubstring: '<bpmn:outgoing>')
		description: '<bpmn:process> must not contain <outgoing> flow reference'.
	self deny: (xml includesSubstring: '<bpmn:incoming>')
		description: '<bpmn:process> must not contain <incoming> flow reference'
]

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testSubProcessModelPrintTypeIsCamelCase [
	self assert: OPBPMNSubProcessModel new printType equals: 'subProcess'
]

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testVisitDefinitionsIncludesTargetNamespace [
	| mockRoot mockModel visitor xml |
	mockModel := OPBPMNModel new.
	mockModel name: 'Test Model'.
	mockModel isExecutable: false.
	mockRoot := Mock new.
	mockRoot stub model willReturn: mockModel.
	mockRoot stub controllers willReturn: #( ).
	visitor := OPBPMNXMLWriterVisitor new.
	visitor visit: mockRoot.
	xml := visitor contents.
	self assert: (xml includesSubstring: 'targetNamespace="https://openponk.org/"')
		description: 'BPMN 2.0 definitions must declare targetNamespace'.
	XMLDOMParser parse: xml
]

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testVisitDiagramAssociationProducesBpmnEdge [
	| association sourceModel targetModel mockSourceElement mockTargetElement sourceController targetController associationController viewModel visitor xmlContent |
	sourceModel := OPBPMNActivityModel new.
	targetModel := OPBPMNAnnotationModel new.

	association := OPBPMNAssociationModel new.
	association source: sourceModel.
	association target: targetModel.

	mockSourceElement := Mock new.
	mockSourceElement stub position willReturn: 10.0 @ 20.0.

	mockTargetElement := Mock new.
	mockTargetElement stub position willReturn: 100.0 @ 200.0.

	sourceController := OPBPMNActivityController new.
	sourceController diagramElement: mockSourceElement.

	targetController := OPBPMNAnnotationController new.
	targetController diagramElement: mockTargetElement.

	viewModel := OPBPMNAssociationViewModel new.
	viewModel model: association.

	associationController := OPBPMNAssociationController new.
	associationController viewModel: viewModel.
	associationController source: sourceController.
	associationController target: targetController.

	visitor := OPBPMNXMLWriterVisitor new.
	visitor visitDiagramElement: associationController.
	xmlContent := visitor contents.

	self assert: (xmlContent includesSubstring: '<bpmndi:BPMNEdge bpmnElement="_6-' , association uuid asString).
	self assert: (xmlContent includesSubstring: 'x="10.0" y="20.0"').
	self assert: (xmlContent includesSubstring: 'x="100.0" y="200.0"')
]

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testVisitElement [
	| model writerVisitor |
	model := OPBPMNGatewayModel new.
	model name: 'Test name'.
	writerVisitor := OPBPMNXMLWriterVisitor new.
	writerVisitor visitElementEvent: model.
	self
		assert: writerVisitor writer asString
		equals: '<?xml version="1.0" encoding="UTF-8"?>
<bpmn:exclusiveGateway name="Test name" id="_6-' , model uuid asString , '"/>'
]

{ #category : 'tests' }
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

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testVisitElementActivityDoesNotEmitEmptyAttribute [
	| activity visitor xml |
	activity := OPBPMNActivityModel new.
	activity name: 'Check Stock'.
	visitor := OPBPMNXMLWriterVisitor new.
	visitor visitElementActivity: activity.
	xml := visitor writer asString.
	self deny: (xml includesSubstring: '=""') description: 'XML must not contain invalid empty attribute name =""'.
	self assert: (xml includesSubstring: 'id="_6-' , activity uuid asString , '"').
	self assert: (xml includesSubstring: 'name="Check Stock"')
]

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testVisitElementEvent [
	| model writerVisitor |
	model := OPBPMNStartEventModel new.
	model name: 'Test name'.
	model type: OPBPMNNodeType Timer.
	model timerType: 'timeDuration'.
	model timerValue: 'PT5M'.
	writerVisitor := OPBPMNXMLWriterVisitor new.
	writerVisitor visitElementEvent: model.
	self
		assert: writerVisitor writer asString
		equals: '<?xml version="1.0" encoding="UTF-8"?>
<bpmn:startEvent name="Test name" id="_6-' , model uuid asString , '">
    <bpmn:timerEventDefinition id="timerEventDefinition_' , model uuid asString , '">
        <bpmn:timeDuration xsi:type="semantic:tFormalExpression">PT5M</bpmn:timeDuration>
    </bpmn:timerEventDefinition>
</bpmn:startEvent>'
]

{ #category : 'tests' }
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

{ #category : 'tests' }
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

{ #category : 'tests' }
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

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testVisitParticipantRef [
| model writerVisitor|
model := OPBPMNPoolModel new.
model name: 'Test name'.
writerVisitor := OPBPMNXMLWriterVisitor new.
writerVisitor visitParticipantRef: model.
self assert: writerVisitor writer asString equals: '<?xml version="1.0" encoding="UTF-8"?>
<bpmn:participant id="participant_', model uuid asString, '" processRef="_6-', model uuid asString, '"/>'
]
