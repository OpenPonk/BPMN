Class {
	#name : 'OPBPMNStartEventShape',
	#superclass : 'OPBPMNEventShape',
	#instVars : [
		'border'
	],
	#category : 'OpenPonk-BPMN-Shapes',
	#package : 'OpenPonk-BPMN',
	#tag : 'Shapes'
}

{ #category : 'connecting' }
OPBPMNStartEventShape >> createBorder [

	self modelElement
		ifNil: [ 
			border := RSBorder new
				          dashArray: #( 1 0 );
				          color: Color black ]
		ifNotNil: [ 
			self modelElement isNonInterrupting
				ifTrue: [ border dashArray: #( 11 10 ) ]
				ifFalse: [ border dashArray: #( 1 0 ) ] ]
]

{ #category : 'connecting' }
OPBPMNStartEventShape >> createRoassalShape [
	^ RSCircle new
		size: 39;
		borderColor: Color black;
		border: border;
		yourself
]

{ #category : 'connecting' }
OPBPMNStartEventShape >> initialize [
	super initialize.
	self createBorder.
	
]

{ #category : 'connecting' }
OPBPMNStartEventShape >> updateRenderFromModel [

	(roassalShape propertyAt: #RSLabeled) text: self modelElement name.
	self updateIcon.
	self createBorder.
	super updateRenderFromModel.

	roassalShape signalUpdate
]
