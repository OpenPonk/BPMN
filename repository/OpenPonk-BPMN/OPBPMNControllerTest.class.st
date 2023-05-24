Class {
	#name : #OPBPMNControllerTest,
	#superclass : #OPElementControllerTest,
	#instVars : [
		'relationshipController'
	],
	#category : #'OpenPonk-BPMN-Tests'
}

{ #category : #testing }
OPBPMNControllerTest class >> isAbstract [

	^ self = OPBPMNControllerTest
]

{ #category : #accessing }
OPBPMNControllerTest >> controllerClass [
	^ self subclassResponsibility
]

{ #category : #accessing }
OPBPMNControllerTest >> createTargetModel [
	^ self targetModelClass new
]

{ #category : #accessing }
OPBPMNControllerTest >> diagramControllerClass [

	^ OPBPMNDiagramController
]

{ #category : #accessing }
OPBPMNControllerTest >> diagramElementClass [

	^ self subclassResponsibility
]

{ #category : #accessing }
OPBPMNControllerTest >> diagramModelClass [
	^ OPBPMNModel 
]

{ #category : #accessing }
OPBPMNControllerTest >> modelClass [
	^ self subclassResponsibility
]

{ #category : #accessing }
OPBPMNControllerTest >> modelOwner [
	^ diagramController model
]

{ #category : #accessing }
OPBPMNControllerTest >> setUp [
	super setUp.
	self setUpTarget
]

{ #category : #accessing }
OPBPMNControllerTest >> setUpTarget [
	relationshipController := self targetControllerClass new.
	relationshipController diagramController: diagramController.
	relationshipController createModelIn: diagramController model
]

{ #category : #accessing }
OPBPMNControllerTest >> targetControllerClass [
	^ self subclassResponsibility
]

{ #category : #accessing }
OPBPMNControllerTest >> targetModelClass [
	^ self subclassResponsibility
]

{ #category : #accessing }
OPBPMNControllerTest >> testCreateController [
	self assert: controller class equals: self controllerClass
]

{ #category : #accessing }
OPBPMNControllerTest >> testCreateModel [
	controller createModelIn: relationshipController model.
	self assert: controller model class equals: self modelClass
]

{ #category : #accessing }
OPBPMNControllerTest >> testModelClass [
	self assert: controller modelClass equals: self modelClass
]
