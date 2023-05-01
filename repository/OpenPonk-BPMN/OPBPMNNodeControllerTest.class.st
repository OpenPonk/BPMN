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
OPBPMNNodeControllerTest >> controllerClass [
	^ self subclassResponsibility
]

{ #category : #accessing }
OPBPMNNodeControllerTest >> testAssignmentToParent [
	controller createModelIn: relationshipController model.
	self assert: (relationshipController model elements includes: controller model)
]

{ #category : #accessing }
OPBPMNNodeControllerTest >> testClassSideModelClass [
	self assert: self controllerClass modelClass equals: self modelClass
]

{ #category : #accessing }
OPBPMNNodeControllerTest >> testCreateController [
	self assert: controller class = self controllerClass
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
	controller
		createDiagramElement;
		renderDiagramElement.
	self assert:
		(controller roassalShape propertyAt: #RSLabeled) text = ''.
	controller model name: 'new name'.
	controller diagramElement modelChanged.
	text := (controller roassalShape propertyAt: #RSLabeled) text.
	self assert:
		((text last: 8) = 'new name' or: [ (text first: 8) = 'new name' ])
]
