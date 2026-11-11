"
I render a BPMN Activity (such as a Task) as a Roassal bound node, typically drawing a rounded rectangle with dynamic borders and inner markers.
"
Class {
	#name : 'OPBPMNActivityShape',
	#superclass : 'OPBPMNNodeShape',
	#instVars : [
		'border',
		'labeled'
	],
	#category : 'OpenPonk-BPMN-DiagramElements',
	#package : 'OpenPonk-BPMN',
	#tag : 'DiagramElements'
}

{ #category : 'connecting' }
OPBPMNActivityShape >> createBorder [

	self modelElement
		ifNil: [ 
			border := RSBorder new
							width: 1;
				          color: Color black ]
		ifNotNil: [ 
			self modelElement isCallActivity 
				ifTrue: [ border width: 5 ]
				ifFalse: [ border width: 1 ] ]
]

{ #category : 'connecting' }
OPBPMNActivityShape >> createRoassalShape [
	^ RSBox new
		extent: 85@55;
		border: border;
		cornerRadius: 10;
		yourself
	
]

{ #category : 'rendering' }
OPBPMNActivityShape >> createTypeIconShape [
	self modelElement ifNil: [ ^ OPBPMNRoassalIconFactory emptyIcon ].
	^ OPBPMNRoassalIconFactory activityIconForType: self modelElement type
]

{ #category : 'rendering' }
OPBPMNActivityShape >> iconLocation [
	^ RSLocation new
		offset: -28 @ -16;
		yourself
]

{ #category : 'initialization' }
OPBPMNActivityShape >> initialize [

	super initialize.
	self createBorder
]

{ #category : 'removing' }
OPBPMNActivityShape >> removeRender [
	super removeRender.
	labeled := nil
]

{ #category : 'rendering' }
OPBPMNActivityShape >> renderShapeDetails [
	labeled := OPRSLabeled new.
	labeled color: Color black.
	labeled shapeBuilder wrapStrategy: RSWrapStrategy new.
	labeled location middle.
	labeled text: ''.
	roassalShape @ labeled.

	icon := self createTypeIconShape.
	self canvas add: icon.
	self attachIconShape.

	self color: (Color fromHexString: 'f2f2f2')
]

{ #category : 'rendering' }
OPBPMNActivityShape >> updateLabel [
	labeled ifNotNil: [
		labeled text: (self modelElement name ifNil: [ '' ]) ]
]

{ #category : 'rendering' }
OPBPMNActivityShape >> updateRenderFromModel [
	self createBorder.
	super updateRenderFromModel
]
