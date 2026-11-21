"
Verifies BPMN domain model printing, node and edge predicates, containment queries, and association/flow mutation idempotency.
"
Class {
	#name : 'OPBPMNModelTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-BPMN-Tests-Models',
	#package : 'OpenPonk-BPMN-Tests',
	#tag : 'Models'
}

{ #category : 'tests' }
OPBPMNModelTest >> testActivityModelPrintTypeForAllTypes [

	| activityModel expectedByType |
	expectedByType := {
		                  (OPBPMNNodeType Service -> 'serviceTask').
		                  (OPBPMNNodeType User -> 'userTask').
		                  (OPBPMNNodeType Manual -> 'manualTask').
		                  (OPBPMNNodeType Send -> 'sendTask').
		                  (OPBPMNNodeType Receive -> 'receiveTask').
		                  (OPBPMNNodeType None -> 'task') }.
	expectedByType do: [ :eachPair |
			activityModel := OPBPMNActivityModel new type: eachPair key.
			self assert: activityModel printType equals: eachPair value ]
]

{ #category : 'tests' }
OPBPMNModelTest >> testAddAndRemoveAssociationAreIdempotent [

	| taskModel annotationModel associationModel |
	taskModel := OPBPMNActivityModel new name: 'Task'.
	annotationModel := OPBPMNAnnotationModel new text: 'Note'.
	associationModel := OPBPMNAssociationModel from: annotationModel to: taskModel.

	annotationModel addAssociation: associationModel.
	annotationModel addAssociation: associationModel.
	self assert: annotationModel associations size equals: 1.

	annotationModel removeAssociation: associationModel.
	annotationModel removeAssociation: associationModel.
	self assertEmpty: annotationModel associations
]

{ #category : 'tests' }
OPBPMNModelTest >> testAddAndRemoveFlowAreIdempotent [

	| sourceTask targetTask flowModel |
	sourceTask := OPBPMNActivityModel new name: 'Source'.
	targetTask := OPBPMNActivityModel new name: 'Target'.
	flowModel := OPBPMNFlowModel from: sourceTask to: targetTask.

	sourceTask addFlow: flowModel.
	sourceTask addFlow: flowModel.
	self assert: sourceTask flows size equals: 1.

	sourceTask removeFlow: flowModel.
	sourceTask removeFlow: flowModel.
	self assertEmpty: sourceTask flows
]

{ #category : 'tests' }
OPBPMNModelTest >> testGatewayModelPrintTypeForAllTypes [

	| gatewayModel expectedByType |
	expectedByType := {
		                  (OPBPMNNodeType Parallel -> 'parallelGateway').
		                  (OPBPMNNodeType Inclusive -> 'inclusiveGateway').
		                  (OPBPMNNodeType Exclusive -> 'exclusiveGateway').
		                  (OPBPMNNodeType ExclusiveEmpty -> 'exclusiveGateway').
		                  (OPBPMNNodeType Complex -> 'complexGateway').
		                  (OPBPMNNodeType Eventbased -> 'eventBasedGateway').
		                  (OPBPMNNodeType None -> 'exclusiveGateway') }.
	expectedByType do: [ :eachPair |
			gatewayModel := OPBPMNGatewayModel new type: eachPair key.
			self assert: gatewayModel printType equals: eachPair value ]
]

{ #category : 'tests' }
OPBPMNModelTest >> testLaneModelPrintType [

	self assert: OPBPMNLaneModel new printType equals: 'lane'
]

{ #category : 'tests' }
OPBPMNModelTest >> testNodeAndEdgePredicatesAndEdgesAccessors [

	| bpmnModel sourceTask targetTask annotationModel flowModel associationModel |
	bpmnModel := OPBPMNModel named: 'Predicates'.
	sourceTask := OPBPMNActivityModel new name: 'Source'.
	targetTask := OPBPMNActivityModel new name: 'Target'.
	annotationModel := OPBPMNAnnotationModel new text: 'Note'.
	flowModel := OPBPMNFlowModel from: sourceTask to: targetTask.
	associationModel := OPBPMNAssociationModel from: annotationModel to: sourceTask.
	bpmnModel
		add: sourceTask;
		add: targetTask;
		add: flowModel.
	sourceTask
		addFlow: flowModel;
		addAssociation: associationModel.
	annotationModel addAssociation: associationModel.

	self assert: sourceTask isNode description: 'BPMN node model must answer true to isNode'.
	self deny: sourceTask isEdge description: 'BPMN node model must answer false to isEdge'.
	self assert: flowModel isEdge description: 'BPMN edge model must answer true to isEdge'.
	self deny: flowModel isNode description: 'BPMN edge model must answer false to isNode'.
	self assertCollection: bpmnModel nodes hasSameElements: {
			sourceTask.
			targetTask }.
	self assertCollection: bpmnModel edges hasSameElements: { flowModel }.
	self assertCollection: annotationModel edges hasSameElements: { associationModel }.
	self assertCollection: sourceTask edges hasSameElements: {
			associationModel.
			flowModel }
]

{ #category : 'tests' }
OPBPMNModelTest >> testSemanticNodeHasChecksAssociationsAndFlows [

	| sourceTask targetTask annotationModel flowModel associationModel unrelatedTask |
	sourceTask := OPBPMNActivityModel new name: 'Source'.
	targetTask := OPBPMNActivityModel new name: 'Target'.
	unrelatedTask := OPBPMNActivityModel new name: 'Other'.
	annotationModel := OPBPMNAnnotationModel new text: 'Note'.
	flowModel := OPBPMNFlowModel from: sourceTask to: targetTask.
	associationModel := OPBPMNAssociationModel from: annotationModel to: sourceTask.
	sourceTask
		addFlow: flowModel;
		addAssociation: associationModel.

	self assert: (sourceTask has: flowModel) description: 'Semantic node must report true for attached flow'.
	self assert: (sourceTask has: associationModel) description: 'Semantic node must report true for attached association'.
	self deny: (sourceTask has: unrelatedTask) description: 'Semantic node must report false for unrelated element'
]
