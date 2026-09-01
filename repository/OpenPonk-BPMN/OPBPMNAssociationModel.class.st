"
I represent a BPMN Association. I track the relationship between an artifact and a flow object, explicitly managing the visual directionality (none, one, or both).
"
Class {
	#name : 'OPBPMNAssociationModel',
	#superclass : 'OPBPMNEdgeModel',
	#instVars : [
		'associationDirection'
	],
	#category : 'OpenPonk-BPMN-Models',
	#package : 'OpenPonk-BPMN',
	#tag : 'Models'
}

{ #category : 'accessing' }
OPBPMNAssociationModel class >> allAssociationDirections [

	^ {
		  self associationDirectionNone.
		  self associationDirectionOne.
		  self associationDirectionBoth }
]

{ #category : 'accessing' }
OPBPMNAssociationModel class >> associationDirectionBoth [

	^ #Both
]

{ #category : 'accessing' }
OPBPMNAssociationModel class >> associationDirectionNone [

	^ #None
]

{ #category : 'accessing' }
OPBPMNAssociationModel class >> associationDirectionOne [

	^ #One
]

{ #category : 'accessing' }
OPBPMNAssociationModel >> associationDirection [

	^ associationDirection
]

{ #category : 'accessing' }
OPBPMNAssociationModel >> associationDirection: aSymbol [

	associationDirection := aSymbol
]

{ #category : 'initialization' }
OPBPMNAssociationModel >> initialize [

	super initialize.
	self associationDirection: self class associationDirectionNone
]

{ #category : 'testing' }
OPBPMNAssociationModel >> isToSource [

	^ self associationDirection = self class associationDirectionBoth
]

{ #category : 'testing' }
OPBPMNAssociationModel >> isToTarget [

	^ self associationDirection ~= self class associationDirectionNone
]
