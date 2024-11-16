Class {
	#name : 'OPBPMNNodeControllerTest',
	#superclass : 'OPAbstractElementControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'testing' }
OPBPMNNodeControllerTest class >> isAbstract [
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^ self = OPBPMNNodeControllerTest
]

{ #category : 'accessing' }
OPBPMNNodeControllerTest >> diagramControllerClass [

	^ OPBPMNDiagramController
]

{ #category : 'accessing' }
OPBPMNNodeControllerTest >> diagramModelClass [
	^ OPBPMNModel 
]

{ #category : 'accessing' }
OPBPMNNodeControllerTest >> testFigureRefresh [

	| text |
	controller createModelIn: diagramController model.
	diagramController addController: controller.
	controller
		createDiagramElement;
		renderDiagramElement.
	self assert:
		(controller roassalShape propertyAt: #RSLabeled) text = ''.
	controller model name: 'new name'.
	controller modelChanged.
	text := (controller roassalShape propertyAt: #RSLabeled) text.
	self assert:
		((text last: 8) = 'new name' or: [ (text first: 8) = 'new name' ])
]
