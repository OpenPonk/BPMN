"
I am an abstract base test class verifying common initialization, targeting, and rendering logic for generic BPMN node controllers.
"
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

{ #category : 'hooks' }
OPBPMNNodeControllerTest >> canBeAssociationSource [
	"Hook specifying whether this node controller can act as an association source."
	^ true
]

{ #category : 'hooks' }
OPBPMNNodeControllerTest >> canBeAssociationTarget [
	"Hook specifying whether this node controller can act as an association target."
	^ true
]

{ #category : 'constants' }
OPBPMNNodeControllerTest >> diagramControllerClass [

	^ OPBPMNDiagramController
]

{ #category : 'constants' }
OPBPMNNodeControllerTest >> diagramModelClass [

	^ OPBPMNModel
]

{ #category : 'testing - association' }
OPBPMNNodeControllerTest >> newCompatibleSourceForAssociation [
	"Answers an initialized controller compatible as an association source for testing."
	| sourceModel |
	sourceModel := (controller isKindOf: OPBPMNAnnotationController)
		ifTrue: [ OPBPMNActivityModel new ]
		ifFalse: [ OPBPMNAnnotationModel new ].
	^ diagramController newControllerFor: sourceModel
]

{ #category : 'testing - association' }
OPBPMNNodeControllerTest >> newCompatibleTargetForAssociation [
	"Answers an initialized controller compatible as an association target for testing."
	| targetModel |
	targetModel := (controller isKindOf: OPBPMNAnnotationController)
		ifTrue: [ OPBPMNActivityModel new ]
		ifFalse: [ OPBPMNAnnotationModel new ].
	^ diagramController newControllerFor: targetModel
]

{ #category : 'testing - association' }
OPBPMNNodeControllerTest >> showCompatibleControllerInDiagram: aController [
	"Shows the given compatible controller and its model inside the test diagram."
	diagramController model add: aController model.
	diagramController addController: aController.
	aController showWithoutDependentInDiagram: diagramController
]

{ #category : 'tests' }
OPBPMNNodeControllerTest >> testCanBeAssociationSource [
	| assocController targetController |
	assocController := OPBPMNAssociationController new.
	assocController diagramController: diagramController.

	self assert: (controller canBeSourceFor: assocController) equals: self canBeAssociationSource.
	self canBeAssociationSource ifFalse: [ ^ self ].

	self showInDiagram.
	targetController := self newCompatibleTargetForAssociation.
	self showCompatibleControllerInDiagram: targetController.

	assocController source: controller.
	assocController target: targetController.
	assocController createModelIn: diagramController model.
	diagramController addController: assocController.

	assocController createDiagramElement.
	assocController renderDiagramElement.

	self assert: assocController diagramElement isNotNil.
	self assert: assocController roassalShape isNotNil.
	self assert: assocController roassalShape from equals: controller roassalShape.
	self assert: assocController roassalShape to equals: targetController roassalShape
]

{ #category : 'tests' }
OPBPMNNodeControllerTest >> testCanBeAssociationTarget [
	| assocController sourceController |
	assocController := OPBPMNAssociationController new.
	assocController diagramController: diagramController.

	sourceController := self newCompatibleSourceForAssociation.
	assocController source: sourceController.

	self assert: (controller canBeTargetFor: assocController) equals: self canBeAssociationTarget.
	self canBeAssociationTarget ifFalse: [ ^ self ].

	self showInDiagram.
	self showCompatibleControllerInDiagram: sourceController.

	assocController target: controller.
	assocController createModelIn: diagramController model.
	diagramController addController: assocController.

	assocController createDiagramElement.
	assocController renderDiagramElement.

	self assert: assocController diagramElement isNotNil.
	self assert: assocController roassalShape isNotNil.
	self assert: assocController roassalShape from equals: sourceController roassalShape.
	self assert: assocController roassalShape to equals: controller roassalShape
]
