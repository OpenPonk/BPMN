Class {
	#name : #OPBPMNNodeControllerTest,
	#superclass : #OPBPMNControllerTest,
	#category : #'OpenPonk-BPMN-Tests'
}

{ #category : #testing }
OPBPMNNodeControllerTest class >> isAbstract [
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^ self = OPBPMNNodeControllerTest
]

{ #category : #accessing }
OPBPMNNodeControllerTest >> testClassSideModelClass [
	self assert: self controllerClass modelClass equals: self modelClass
]

{ #category : #accessing }
OPBPMNNodeControllerTest >> testCreateFigure [
	controller createModelIn: diagramController model.
	diagramController addController: controller.
	controller renderFigureIn: diagramController view.
	self assert: controller figure class equals: RTElement
]

{ #category : #accessing }
OPBPMNNodeControllerTest >> testCreateModel [
	self
		assert: (controller createModelIn: diagramController model) class
		equals: self modelClass
]

{ #category : #accessing }
OPBPMNNodeControllerTest >> testFigureRefresh [
	| text |
	controller createModelIn: diagramController model.
	diagramController addController: controller.
	controller renderFigureIn: diagramController view.
	self
		assert: (controller figure attributeAt: #RTLabelledLabel) text
		equals: ''.
	controller model name: 'new name'.
	controller refreshFigure.
	text := (controller figure attributeAt: #RTLabelledLabel) text.
	self
		assert: ((text last: 8) = 'new name' or: [ (text first: 8) = 'new name' ])
]
