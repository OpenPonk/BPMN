Class {
	#name : 'OPBPMNDiagramControllerTest',
	#superclass : 'OPAbstractDiagramControllerTest',
	#category : 'OpenPonk-BPMN-Controllers',
	#package : 'OpenPonk-BPMN',
	#tag : 'Controllers'
}

{ #category : 'accessing' }
OPBPMNDiagramControllerTest >> controllerClass [
	^ OPBPMNDiagramController
]

{ #category : 'accessing' }
OPBPMNDiagramControllerTest >> diagramModelClass [
	^ OPBPMNModel
]

{ #category : 'accessing' }
OPBPMNDiagramControllerTest >> modelClass [
	^ OPBPMNModel
]

{ #category : 'tests' }
OPBPMNDiagramControllerTest >> testControllerFactory [
	self assert: controller controllerFactory isNotNil.
	self assert: (controller controllerFactory isKindOf: OPControllerFactory)
]

{ #category : 'tests' }
OPBPMNDiagramControllerTest >> testInitializePalette [
	| palette |
	palette := OPPalette new.
	controller initializePalette: palette.
	self denyCollection: palette items hasSameElements: #()
]
