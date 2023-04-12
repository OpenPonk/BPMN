Class {
	#name : #OPBPMNControllerTest,
	#superclass : #AnObsoleteOPElementControllerTest,
	#category : #'OpenPonk-BPMN-Tests'
}

{ #category : #testing }
OPBPMNControllerTest class >> isAbstract [
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^ self = OPBPMNControllerTest
]

{ #category : #accessing }
OPBPMNControllerTest >> controllerClass [
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
OPBPMNControllerTest >> testClassSideModelClass [
	self assert: self controllerClass modelClass equals: self modelClass
]

{ #category : #accessing }
OPBPMNControllerTest >> testCreateController [
	self assert: controller class equals: self controllerClass
]

{ #category : #accessing }
OPBPMNControllerTest >> testModelClass [
	self assert: controller modelClass equals: self modelClass
]
