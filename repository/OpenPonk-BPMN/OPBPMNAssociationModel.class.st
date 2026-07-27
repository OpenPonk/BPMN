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
