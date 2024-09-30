Class {
	#name : 'OPBPMNEdgeControllerTest',
	#superclass : 'OPAbstractDirectionalRelationshipControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'testing' }
OPBPMNEdgeControllerTest class >> isAbstract [
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^ self = OPBPMNEdgeControllerTest
]

{ #category : 'tests' }
OPBPMNEdgeControllerTest >> amountOfLabels [
	^ 1
]

{ #category : 'initialization' }
OPBPMNEdgeControllerTest >> assignModelSource [

	super assignModelSource.
	model source addFlow: model
]

{ #category : 'initialization' }
OPBPMNEdgeControllerTest >> assignModelTarget [

	super assignModelTarget.
	model target addFlow: model
]

{ #category : 'accessing' }
OPBPMNEdgeControllerTest >> diagramControllerClass [

	^ OPBPMNDiagramController
]

{ #category : 'accessing' }
OPBPMNEdgeControllerTest >> diagramModelClass [
	^ OPBPMNModel 
]

{ #category : 'tests' }
OPBPMNEdgeControllerTest >> testCreateUsingAddAsTarget [

	| figure |
	super testCreateUsingAddAsTarget.
	figure := controller roassalShape.
	self assert: figure class equals: OPRSPolyline.
	self assert: figure from equals: self sourceController roassalShape.
	self assert: figure to equals: self targetController roassalShape.
	self assert: figure shape color equals: Color black
]

{ #category : 'tests' }
OPBPMNEdgeControllerTest >> testFigureRefresh [

	| label |
	self showInDiagram.
	label := controller diagramElement ownedElements first.
	self assert: label roassalShape text equals: ''.
	controller model name: 'new name'.
	controller diagramElement modelChanged.
	self assert: label roassalShape text equals: 'new name'
]
