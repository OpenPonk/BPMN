"
I am an abstract base test class verifying common assignment and relationship logic for directional BPMN edge controllers.
"
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

{ #category : 'hooks' }
OPBPMNEdgeControllerTest >> canBeAssociationSource [
	"Hook specifying whether this edge controller can act as an association source."
	^ false
]

{ #category : 'hooks' }
OPBPMNEdgeControllerTest >> canBeAssociationTarget [
	"Hook specifying whether this edge controller can act as an association target."
	^ false
]

{ #category : 'constants' }
OPBPMNEdgeControllerTest >> diagramControllerClass [

	^ OPBPMNDiagramController
]

{ #category : 'constants' }
OPBPMNEdgeControllerTest >> diagramModelClass [

	^ OPBPMNModel
]

{ #category : 'tests - association' }
OPBPMNEdgeControllerTest >> testCanBeAssociationSource [
	"Verifies that edge controllers correctly decline or accept acting as association sources."
	| assocController |
	assocController := OPBPMNAssociationController new.
	assocController diagramController: diagramController.
	self assert: (controller canBeSourceFor: assocController) equals: self canBeAssociationSource
]

{ #category : 'tests - association' }
OPBPMNEdgeControllerTest >> testCanBeAssociationTarget [
	"Verifies that edge controllers correctly decline or accept acting as association targets."
	| assocController |
	assocController := OPBPMNAssociationController new.
	assocController diagramController: diagramController.
	assocController source: self sourceController.
	self assert: (controller canBeTargetFor: assocController) equals: self canBeAssociationTarget
]
