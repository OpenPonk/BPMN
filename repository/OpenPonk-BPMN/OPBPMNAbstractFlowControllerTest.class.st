Class {
	#name : 'OPBPMNAbstractFlowControllerTest',
	#superclass : 'OPBPMNEdgeControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'testing' }
OPBPMNAbstractFlowControllerTest class >> isAbstract [
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^ self = OPBPMNAbstractFlowControllerTest
]

{ #category : 'initialization' }
OPBPMNAbstractFlowControllerTest >> assignModelSource [

	super assignModelSource.
	model source addFlow: model
]

{ #category : 'initialization' }
OPBPMNAbstractFlowControllerTest >> assignModelTarget [

	super assignModelTarget.
	model target addFlow: model
]

{ #category : 'tests' }
OPBPMNAbstractFlowControllerTest >> testCreateUsingAddAsTarget [

	| figure |
	super testCreateUsingAddAsTarget.
	figure := controller roassalShape.
	self assert: figure class equals: OPRSPolyline.
	self assert: figure from equals: self sourceController roassalShape.
	self assert: figure to equals: self targetController roassalShape.
	self assert: figure shape color equals: Color black
]

{ #category : 'tests' }
OPBPMNAbstractFlowControllerTest >> testFigureRefresh [

	| label |
	self showInDiagram.
	label := controller diagramElement ownedElements first.
	self assert: label roassalShape text equals: ''.
	controller model name: 'new name'.
	controller modelChanged.
	self assert: label roassalShape text equals: 'new name'
]
