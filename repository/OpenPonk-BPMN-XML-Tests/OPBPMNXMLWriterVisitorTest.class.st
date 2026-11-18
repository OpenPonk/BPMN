"
I am a unit test class verifying the correct serialization and conversion of BPMN model elements (activities, flows, participants, events) into XML format by the visitor.
"
Class {
	#name : 'OPBPMNXMLWriterVisitorTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-BPMN-XML-Tests-Writer',
	#package : 'OpenPonk-BPMN-XML-Tests',
	#tag : 'Writer'
}

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testActivityIncomingContainsOnlySequenceFlows [

	| activity sourceActivity sequenceFlow annotation association visitor xml expectedXml unexpectedIncoming |
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

	expectedXml := String streamContents: [ :stream |
			               stream nextPutAll: '<?xml version="1.0" encoding="UTF-8"?>'.
			               stream cr.
			               stream nextPutAll: '<bpmn:task name="Check Stock" id="_6-'.
			               stream nextPutAll: activity uuid asString.
			               stream nextPutAll: '">'.
			               stream cr.
			               stream nextPutAll: '    <bpmn:incoming>'.
			               stream nextPutAll: sequenceFlow printIdType.
			               stream nextPutAll: sequenceFlow uuid asString.
			               stream nextPutAll: '</bpmn:incoming>'.
			               stream cr.
			               stream nextPutAll: '</bpmn:task>' ].
	unexpectedIncoming := String streamContents: [ :stream |
			                      stream nextPutAll: '<bpmn:incoming>'.
			                      stream nextPutAll: association printIdType.
			                      stream nextPutAll: association uuid asString.
			                      stream nextPutAll: '</bpmn:incoming>' ].
	self assert: xml equals: expectedXml.
	self
		deny: (xml includesSubstring: unexpectedIncoming)
		description: 'Associations must not be exported as <incoming> flow references'
]

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testBoundaryEventExportsAttachedToRef [

	| subProcess boundaryEvent visitor xml expectedXml |
	subProcess := OPBPMNSubProcessModel new.
	subProcess name: 'Procure Items'.

	boundaryEvent := OPBPMNBoundaryEventModel new.
	boundaryEvent name: '2 Days SLA'.
	boundaryEvent instVarNamed: #owner put: subProcess.

	visitor := OPBPMNXMLWriterVisitor new.
	visitor visitElement: boundaryEvent.
	xml := visitor writer asString.

	expectedXml := String streamContents: [ :stream |
			               stream nextPutAll: '<?xml version="1.0" encoding="UTF-8"?>'.
			               stream cr.
			               stream nextPutAll: '<bpmn:boundaryEvent id="_6-'.
			               stream nextPutAll: boundaryEvent uuid asString.
			               stream nextPutAll: '" name="2 Days SLA" attachedToRef="'.
			               stream nextPutAll: subProcess printIdType.
			               stream nextPutAll: subProcess uuid asString.
			               stream nextPutAll: '"/>' ].
	self assert: xml equals: expectedXml
]

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testBoundaryEventModelPrintTypeIsBoundaryEvent [
	self assert: OPBPMNBoundaryEventModel new printType equals: 'boundaryEvent'
]

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testCustomNamespacePrefix [

	| visitor task xml |
	task := OPBPMNActivityModel new
		        name: 'Custom';
		        yourself.
	visitor := OPBPMNXMLWriterVisitor new.
	visitor namespace: 'semantic:'.
	visitor visitElement: task.
	xml := visitor contents.
	self
		assert: (xml includesSubstring: '<semantic:task name="Custom"')
		description: 'Visitor must use custom namespace prefix when configured'
]

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testExportAnnotationDoesNotCrashOnPrintType [

	| annotation visitor xmlContent expectedXml |
	annotation := OPBPMNAnnotationModel new.
	annotation text: 'Implementation notes'.

	visitor := OPBPMNXMLWriterVisitor new.
	visitor visitElement: annotation.
	xmlContent := visitor contents.

	expectedXml := String streamContents: [ :stream |
			               stream nextPutAll: '<?xml version="1.0" encoding="UTF-8"?>'.
			               stream cr.
			               stream nextPutAll: '<bpmn:textAnnotation id="_6-'.
			               stream nextPutAll: annotation uuid asString.
			               stream nextPutAll: '">'.
			               stream cr.
			               stream nextPutAll: '    <bpmn:text>Implementation notes</bpmn:text>'.
			               stream cr.
			               stream nextPutAll: '</bpmn:textAnnotation>' ].
	self assert: xmlContent equals: expectedXml
]

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testExportAssociationDoesNotCrashOnPrintIdType [

	| task annotation association visitor xmlContent expectedXml |
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

	expectedXml := String streamContents: [ :stream |
			               stream nextPutAll: '<?xml version="1.0" encoding="UTF-8"?>'.
			               stream cr.
			               stream nextPutAll: '<bpmn:association id="_6-'.
			               stream nextPutAll: association uuid asString.
			               stream nextPutAll: '" sourceRef="_6-'.
			               stream nextPutAll: task uuid asString.
			               stream nextPutAll: '" targetRef="_6-'.
			               stream nextPutAll: annotation uuid asString.
			               stream nextPutAll: '" associationDirection="None"/>' ].
	self assert: xmlContent equals: expectedXml
]

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testExportBoundaryEventWithTimerDoesNotCrashOnTimerType [

	| boundaryEvent visitor xml expectedXml |
	boundaryEvent := OPBPMNBoundaryEventModel new.
	boundaryEvent name: '2 Days SLA'.
	boundaryEvent type: OPBPMNNodeType Timer.

	visitor := OPBPMNXMLWriterVisitor new.
	visitor visitElementBoundaryEvent: boundaryEvent.
	xml := visitor writer asString.

	expectedXml := String streamContents: [ :stream |
			               stream nextPutAll: '<?xml version="1.0" encoding="UTF-8"?>'.
			               stream cr.
			               stream nextPutAll: '<bpmn:boundaryEvent id="_6-'.
			               stream nextPutAll: boundaryEvent uuid asString.
			               stream nextPutAll: '" name="2 Days SLA">'.
			               stream cr.
			               stream nextPutAll: '    <bpmn:timerEventDefinition id="timerEventDefinition_'.
			               stream nextPutAll: boundaryEvent uuid asString.
			               stream nextPutAll: '"/>'.
			               stream cr.
			               stream nextPutAll: '</bpmn:boundaryEvent>' ].
	self assert: xml equals: expectedXml
]

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testExportCollapsedSubProcessCallActivity [

	| subProcess visitor xmlContent expectedXml |
	subProcess := OPBPMNCollapsedSubProcessModel new.
	subProcess name: 'External Service'.
	subProcess isCallActivity: true.

	visitor := OPBPMNXMLWriterVisitor new.
	visitor visitElement: subProcess.
	xmlContent := visitor contents.

	expectedXml := String streamContents: [ :stream |
			               stream nextPutAll: '<?xml version="1.0" encoding="UTF-8"?>'.
			               stream cr.
			               stream nextPutAll: '<bpmn:callActivity name="External Service" id="_6-'.
			               stream nextPutAll: subProcess uuid asString.
			               stream nextPutAll: '"/>' ].
	self assert: xmlContent equals: expectedXml
]

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testExportCollapsedSubProcessDoesNotCrash [

	| subProcess visitor xmlContent expectedXml |
	subProcess := OPBPMNCollapsedSubProcessModel new.
	subProcess name: 'Order Processing'.

	visitor := OPBPMNXMLWriterVisitor new.
	visitor visitElement: subProcess.
	xmlContent := visitor contents.

	expectedXml := String streamContents: [ :stream |
			               stream nextPutAll: '<?xml version="1.0" encoding="UTF-8"?>'.
			               stream cr.
			               stream nextPutAll: '<bpmn:subProcess name="Order Processing" id="_6-'.
			               stream nextPutAll: subProcess uuid asString.
			               stream nextPutAll: '"/>' ].
	self assert: xmlContent equals: expectedXml
]

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testExportDiagramControllerExampleOrderFulfillmentProducesBPMNDiagram [

	| model project projectController controller xml document shapes edges |
	model := OPBPMNExamples exampleOrderFulfillment.
	project := OPProject named: 'Test'.
	project addModel: model.
	projectController := OPProjectController forProject: project.
	controller := OPBPMNDiagramController new.
	projectController addDiagramController: controller.
	controller model: model.
	controller diagramElement: (OPOpenPonkDiagram forModelElement: model).
	controller canvasPresenter: (OPHeadlessCanvasPresenter new
			 canvas: RSCanvas new;
			 yourself).
	controller showAllElements.
	xml := OPBPMNXMLWriter toString: controller.
	document := XMLDOMParser parse: xml.
	self assert: (document allElementsNamed: 'bpmndi:BPMNDiagram') size equals: 1.
	self assert: (document allElementsNamed: 'bpmndi:BPMNPlane') size equals: 1.
	shapes := document allElementsNamed: 'bpmndi:BPMNShape'.
	edges := document allElementsNamed: 'bpmndi:BPMNEdge'.
	self assert: shapes size equals: 19.
	self assert: edges size equals: 14.
	self
		assert: (shapes anySatisfy: [ :each | (each attributeAt: 'bpmnElement') beginsWith: 'participant_' ])
		description: 'Pools must be exported as BPMNShape referencing participant_ ID'
]

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testExportExampleOrderFulfillmentSucceedsAndIsWellFormed [

	| model xml document |
	model := OPBPMNExamples exampleOrderFulfillment.
	xml := OPBPMNXMLWriter toString: model.
	document := XMLDOMParser parse: xml.

	self assert: document root name equals: 'bpmn:definitions'.
	self assert: (document root attributeAt: 'targetNamespace') equals: 'https://openponk.org/'
]

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testExportPoolAndRootProcessExportsBoundaryEventAttachedToActivity [
	| pool lane task boundaryEvent visitor xml |
	pool := OPBPMNPoolModel new name: 'Pool'.
	lane := OPBPMNLaneModel new name: 'Lane'.
	pool addLane: lane.
	task := OPBPMNActivityModel new name: 'TaskWithBoundary'.
	boundaryEvent := OPBPMNBoundaryEventModel new
		name: 'TaskTimer';
		type: OPBPMNNodeType Timer;
		yourself.
	task add: boundaryEvent.
	lane add: task.

	visitor := OPBPMNXMLWriterVisitor new.
	visitor visitElement: pool.
	xml := visitor writer asString.

	self
		assert: (xml includesSubstring: '<bpmn:boundaryEvent')
		description: 'Boundary event attached to an activity inside a lane must be exported to XML'.
	self
		assert: (xml includesSubstring: 'attachedToRef="' , task printIdType , task uuid asString , '" ') not & (xml includesSubstring: 'attachedToRef="' , task printIdType , task uuid asString , '"')
		description: 'Boundary event must reference its host activity in attachedToRef'
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
OPBPMNXMLWriterVisitorTest >> testExportPoollessModelExportsAssociationsDataFlowsAndBoundaryEvents [

	| model task annotation association dataObject dataFlow boundaryEvent xml |
	model := OPBPMNModel new.
	model name: 'Poolless'.
	task := OPBPMNActivityModel new
		        name: 'Task 1';
		        yourself.
	annotation := OPBPMNAnnotationModel new
		              text: 'Note';
		              yourself.
	association := OPBPMNAssociationModel new
		               source: annotation;
		               target: task;
		               yourself.
	annotation addAssociation: association.
	task addAssociation: association.
	dataObject := OPBPMNDataObjectModel new
		              name: 'Data 1';
		              yourself.
	dataFlow := OPBPMNDataFlowModel from: dataObject to: task.
	dataObject addFlow: dataFlow.
	task addFlow: dataFlow.
	boundaryEvent := OPBPMNBoundaryEventModel new
		                 name: 'Timeout';
		                 type: OPBPMNNodeType Timer;
		                 yourself.
	task add: boundaryEvent.
	model
		add: task;
		add: annotation;
		add: dataObject.
	xml := OPBPMNXMLWriter toString: model.
	self
		assert: (xml includesSubstring: '<bpmn:association id="_6-' , association uuid asString)
		description: 'Poolless BPMN process must export associations'.
	self
		assert: (xml includesSubstring: dataFlow printIdType , dataFlow uuid asString)
		description: 'Poolless BPMN process must export data flows'.
	self
		assert: (xml includesSubstring: '<bpmn:boundaryEvent id="_6-' , boundaryEvent uuid asString)
		description: 'Poolless BPMN process must export boundary events attached to top-level nodes'
]

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testExportSubProcessExportsBoundaryEventAttachedToInnerTask [

	| subProcess innerTask boundaryEvent visitor xml expectedIdFragment expectedRefFragment |
	subProcess := OPBPMNSubProcessModel new
		              name: 'Sub';
		              yourself.
	innerTask := OPBPMNActivityModel new
		             name: 'Inner Task';
		             yourself.
	boundaryEvent := OPBPMNBoundaryEventModel new
		                 name: 'Inner Timer';
		                 type: OPBPMNNodeType Timer;
		                 yourself.
	innerTask add: boundaryEvent.
	subProcess add: innerTask.
	visitor := OPBPMNXMLWriterVisitor new.
	visitor visitElement: subProcess.
	xml := visitor contents.
	expectedIdFragment := '<bpmn:boundaryEvent id="_6-' , boundaryEvent uuid asString.
	expectedRefFragment := String streamContents: [ :stream |
			                       stream nextPutAll: 'attachedToRef="_6-'.
			                       stream nextPutAll: innerTask uuid asString.
			                       stream nextPutAll: '"' ].
	self
		assert: (xml includesSubstring: expectedIdFragment)
		description: 'SubProcess must export boundary events attached to inner tasks'.
	self assert: (xml includesSubstring: expectedRefFragment) description: 'Inner boundary event must reference its inner host task'
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
OPBPMNXMLWriterVisitorTest >> testIntermediateEventPrintTypeDistinguishesCatchAndThrowTypes [
	| catchTypes throwTypes |
	catchTypes := {
		OPBPMNNodeType Receive .
		OPBPMNNodeType Timer .
		OPBPMNNodeType Escalation .
		OPBPMNNodeType Conditional .
		OPBPMNNodeType Link .
		OPBPMNNodeType Compensation .
		OPBPMNNodeType Signal .
		OPBPMNNodeType Multiple .
		OPBPMNNodeType ParallelMultiple }.
	throwTypes := {
		OPBPMNNodeType None .
		OPBPMNNodeType Send .
		OPBPMNNodeType EscalationThrow .
		OPBPMNNodeType LinkThrow .
		OPBPMNNodeType CompensationThrow .
		OPBPMNNodeType SignalThrow .
		OPBPMNNodeType MultipleThrow }.
	catchTypes do: [ :eachCatchType |
		| eventModel |
		eventModel := OPBPMNIntermediateEventModel new type: eachCatchType; yourself.
		self
			assert: eventModel printType
			equals: 'intermediateCatchEvent' ].
	throwTypes do: [ :eachThrowType |
		| eventModel |
		eventModel := OPBPMNIntermediateEventModel new type: eachThrowType; yourself.
		self
			assert: eventModel printType
			equals: 'intermediateThrowEvent' ]
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
OPBPMNXMLWriterVisitorTest >> testVisitBoundaryEventNonInterruptingWithIncomingAndNilName [

	| boundaryEvent sourceTask flow visitor xml |
	sourceTask := OPBPMNActivityModel new
		              name: 'Prev';
		              yourself.
	boundaryEvent := OPBPMNBoundaryEventModel new
		                 name: nil;
		                 isNonInterrupting: true;
		                 type: OPBPMNNodeType None;
		                 yourself.
	flow := OPBPMNFlowModel from: sourceTask to: boundaryEvent.
	sourceTask addFlow: flow.
	boundaryEvent addFlow: flow.
	visitor := OPBPMNXMLWriterVisitor new.
	visitor visitElementBoundaryEvent: boundaryEvent.
	xml := visitor contents.
	self
		assert: (xml includesSubstring: 'name="" cancelActivity="false"')
		description: 'Non-interrupting boundary event with nil name must emit empty name and cancelActivity=false'.
	self
		assert: (xml includesSubstring: '<bpmn:incoming>_6-' , flow uuid asString)
		description: 'Boundary event must export incoming sequence flow reference'
]

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testVisitDefinitionsIncludesTargetNamespace [

	| model project projectController controller visitor xml document diagramElements |
	model := OPBPMNModel new.
	model name: 'Test Model'.
	model isExecutable: false.
	project := OPProject named: 'Test'.
	project addModel: model.
	projectController := OPProjectController forProject: project.
	controller := OPBPMNDiagramController new.
	projectController addDiagramController: controller.
	controller model: model.
	controller diagramElement: (OPOpenPonkDiagram forModelElement: model).
	controller canvasPresenter: (OPHeadlessCanvasPresenter new
			 canvas: RSCanvas new;
			 yourself).
	visitor := OPBPMNXMLWriterVisitor new.
	visitor visit: controller.
	xml := visitor contents.
	document := XMLDOMParser parse: xml.
	self assert: (document root attributeAt: 'targetNamespace') equals: 'https://openponk.org/'.
	diagramElements := document allElementsNamed: 'bpmndi:BPMNDiagram'.
	self assert: diagramElements size equals: 1.
	self assert: (diagramElements first attributeAt: 'name') equals: 'Test Model'
]

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testVisitDiagramAssociationProducesBpmnEdge [

	| association sourceModel targetModel mockSourceElement mockTargetElement sourceController targetController associationController viewModel visitor xmlContent expectedXml |
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

	expectedXml := String streamContents: [ :stream |
			               stream nextPutAll: '<?xml version="1.0" encoding="UTF-8"?>'.
			               stream cr.
			               stream nextPutAll: '<bpmndi:BPMNEdge bpmnElement="_6-'.
			               stream nextPutAll: association uuid asString.
			               stream nextPutAll: '">'.
			               stream cr.
			               stream nextPutAll: '    <di:waypoint x="10.0" y="20.0"/>'.
			               stream cr.
			               stream nextPutAll: '    <di:waypoint x="100.0" y="200.0"/>'.
			               stream cr.
			               stream nextPutAll: '</bpmndi:BPMNEdge>' ].
	self assert: xmlContent equals: expectedXml
]

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testVisitDiagramWithNilModelNameDoesNotCrash [

	| model project projectController controller visitor xml expectedFragment |
	model := OPBPMNModel new.
	model name: nil.
	project := OPProject named: 'Test'.
	project addModel: model.
	projectController := OPProjectController forProject: project.
	controller := OPBPMNDiagramController new.
	projectController addDiagramController: controller.
	controller model: model.
	controller diagramElement: (OPOpenPonkDiagram forModelElement: model).
	controller canvasPresenter: (OPHeadlessCanvasPresenter new
			 canvas: RSCanvas new;
			 yourself).
	visitor := OPBPMNXMLWriterVisitor new.
	visitor visit: controller.
	xml := visitor contents.
	expectedFragment := String streamContents: [ :stream |
			                    stream nextPutAll: '<bpmndi:BPMNDiagram id="BPMNDiagram_'.
			                    stream nextPutAll: model uuid asString.
			                    stream nextPutAll: '" name="" resolution="96.0">' ].
	self
		assert: (xml includesSubstring: expectedFragment)
		description: 'BPMNDiagram name attribute should fall back to empty string when model name is nil'
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

	| activity visitor xml expectedXml |
	activity := OPBPMNActivityModel new.
	activity name: 'Check Stock'.
	visitor := OPBPMNXMLWriterVisitor new.
	visitor visitElementActivity: activity.
	xml := visitor writer asString.

	expectedXml := String streamContents: [ :stream |
			               stream nextPutAll: '<?xml version="1.0" encoding="UTF-8"?>'.
			               stream cr.
			               stream nextPutAll: '<bpmn:task name="Check Stock" id="_6-'.
			               stream nextPutAll: activity uuid asString.
			               stream nextPutAll: '"/>' ].
	self deny: (xml includesSubstring: '=""') description: 'XML must not contain invalid empty attribute name =""'.
	self assert: xml equals: expectedXml
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
OPBPMNXMLWriterVisitorTest >> testVisitEventWithExecutableAttributeAndNilValues [

	| event dataObject visitor xml |
	event := OPBPMNStartEventModel new
		         name: nil;
		         executableAttribute: 'customAttr';
		         executableAttributeValue: nil;
		         type: OPBPMNNodeType Timer;
		         timerType: #timeCycle;
		         timerValue: nil;
		         yourself.
	visitor := OPBPMNXMLWriterVisitor new.
	visitor visitElementEvent: event.
	xml := visitor contents.
	self assert: (xml includesSubstring: 'name=""') description: 'Event with nil name must emit empty name attribute'.
	self
		assert: (xml includesSubstring: 'customAttr=""')
		description: 'Event with nil executableAttributeValue must emit empty attribute value'.
	self
		assert: (xml includesSubstring: '<bpmn:timeCycle xsi:type="semantic:tFormalExpression"/>')
		description: 'Timer event with nil timerValue must emit empty formal expression'.

	dataObject := OPBPMNDataObjectModel new.
	visitor := OPBPMNXMLWriterVisitor new.
	visitor visitElementEventTimer: dataObject.
	self
		assert: (visitor contents includesSubstring: '<bpmn:timerEventDefinition id="timerEventDefinition_' , dataObject uuid asString)
		description: 'visitElementEventTimer: must handle elements without timerType/timerValue'
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
OPBPMNXMLWriterVisitorTest >> testVisitFlowRefOutgoingMessageFlow [

	| pool startEvent messageFlow visitor |
	pool := OPBPMNPoolModel new.
	startEvent := OPBPMNStartEventModel new.
	messageFlow := OPBPMNMessageFlowModel from: pool to: startEvent.
	visitor := OPBPMNXMLWriterVisitor new.
	visitor visitFlowRef: messageFlow inOut: 'outgoing'.
	self assertCollection: visitor allMessageFlows hasSameElements: { messageFlow }
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
OPBPMNXMLWriterVisitorTest >> testVisitFlowWithNilNameDoesNotCrash [

	| modelSource modelTarget flow visitor xml expectedXml |
	modelSource := OPBPMNActivityModel new.
	modelTarget := OPBPMNActivityModel new.
	flow := OPBPMNFlowModel new.
	flow source: modelSource.
	flow target: modelTarget.
	flow name: nil.
	visitor := OPBPMNXMLWriterVisitor new.
	visitor visitFlow: flow type: 'sequenceFlow'.
	xml := visitor contents.
	expectedXml := String streamContents: [ :stream |
			               stream nextPutAll: '<?xml version="1.0" encoding="UTF-8"?>'.
			               stream cr.
			               stream nextPutAll: '<bpmn:sequenceFlow sourceRef="_6-'.
			               stream nextPutAll: modelSource uuid asString.
			               stream nextPutAll: '" targetRef="_6-'.
			               stream nextPutAll: modelTarget uuid asString.
			               stream nextPutAll: '" name="" id="_6-'.
			               stream nextPutAll: flow uuid asString.
			               stream nextPutAll: '"/>' ].
	self assert: xml equals: expectedXml
]

{ #category : 'tests' }
OPBPMNXMLWriterVisitorTest >> testVisitNilFieldsAndPoolWithoutLanesAndRootAnnotation [

	| model pool task annotation subProcess lane activityNil flow visitor xml |
	model := OPBPMNModel new.
	pool := OPBPMNPoolModel new
		        name: nil;
		        yourself.
	lane := OPBPMNLaneModel new
		        name: nil;
		        yourself.
	activityNil := OPBPMNActivityModel new
		               name: nil;
		               executableAttribute: 'attr';
		               executableAttributeValue: nil;
		               yourself.
	annotation := OPBPMNAnnotationModel new
		              text: nil;
		              yourself.
	subProcess := OPBPMNSubProcessModel new
		              name: nil;
		              yourself.
	lane
		add: activityNil;
		add: annotation;
		add: subProcess.
	pool addLane: lane.
	model
		add: pool;
		add: (OPBPMNAnnotationModel new
				 text: 'Root note';
				 yourself).

	visitor := OPBPMNXMLWriterVisitor new.
	visitor visitSemantic: model.
	xml := visitor contents.
	self assert: (xml includesSubstring: '<bpmn:lane name=""') description: 'Lane with nil name must emit empty name'.
	self assert: (xml includesSubstring: '<bpmn:task name=""') description: 'Activity with nil name must emit empty name'.
	self
		assert: (xml includesSubstring: 'attr=""')
		description: 'Activity with nil executableAttributeValue must emit empty attribute'.
	self assert: (xml includesSubstring: '<bpmn:text/>') description: 'Annotation with nil text must emit empty text tag'.
	self assert: (xml includesSubstring: '<bpmn:subProcess name=""') description: 'SubProcess with nil name must emit empty name'.

	model := OPBPMNModel new.
	task := OPBPMNActivityModel new
		        name: 'T1';
		        yourself.
	subProcess := OPBPMNSubProcessModel new
		              name: 'S1';
		              yourself.
	flow := OPBPMNFlowModel from: task to: subProcess.
	task addFlow: flow.
	subProcess addFlow: flow.
	model
		add: task;
		add: subProcess.
	xml := OPBPMNXMLWriter toString: model.
	self assert: (xml includesSubstring: '<bpmn:sequenceFlow') description: 'Poolless BPMN model must export sequence flows'
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
