"
I render a BPMN Data Object as a Roassal bound node, displaying the standard page icon with a folded top-right corner.
"
Class {
	#name : 'OPBPMNDataObjectShape',
	#superclass : 'OPBoundNode',
	#instVars : [
		'icon',
		'borderColor',
		'labeled'
	],
	#category : 'OpenPonk-BPMN-DiagramElements',
	#package : 'OpenPonk-BPMN',
	#tag : 'DiagramElements'
}

{ #category : 'reacting' }
OPBPMNDataObjectShape >> associationCreated: anAssociation [
	"Hook called when an association connected to this shape is created. No specific visual reaction needed."
	
]

{ #category : 'rendering' }
OPBPMNDataObjectShape >> attachIconShape [
	icon ifNil: [ ^ self ].
	RSLocation new stick: icon on: self roassalShape
]

{ #category : 'accessing' }
OPBPMNDataObjectShape >> attachedShapes [

	^ super attachedShapes , { icon }
]

{ #category : 'update' }
OPBPMNDataObjectShape >> borderColor [

	^ borderColor
]

{ #category : 'update' }
OPBPMNDataObjectShape >> color [

	^ self stylePropertyNamed: #fillColor ifAbsent: [ Color transparent ]
]

{ #category : 'update' }
OPBPMNDataObjectShape >> color: aColor [

	^ self stylePropertyNamed: #fillColor put: aColor
]

{ #category : 'update' }
OPBPMNDataObjectShape >> createRoassalShape [
	| composite boundingBox |
	composite := RSComposite new.
	boundingBox := RSBox new
		width: 50;
		height: 50;
		border: (RSBorder new
			width: 1;
			color: Color transparent);
		color: Color transparent.
	composite add: boundingBox.
	composite adjustToChildren.
	^ composite
]

{ #category : 'rendering' }
OPBPMNDataObjectShape >> createTypeIconShape [
	self modelElement ifNil: [
		^ OPBPMNRoassalIconFactory
			dataObjectIconForType: OPBPMNNodeType DataObject
			fillColor: self color
			borderColor: borderColor ].
	^ OPBPMNRoassalIconFactory
		dataObjectIconForType: self modelElement type
		fillColor: self color
		borderColor: borderColor
]

{ #category : 'initialization' }
OPBPMNDataObjectShape >> initialize [

	super initialize.
	borderColor := Color transparent
]

{ #category : 'testing' }
OPBPMNDataObjectShape >> isSecondaryLayoutShape [
	^ true
]

{ #category : 'removing' }
OPBPMNDataObjectShape >> removeRender [
	super removeRender.
	icon := nil.
	labeled := nil
]

{ #category : 'rendering' }
OPBPMNDataObjectShape >> renderBasicShape [

	^ self createRoassalShape model: self
]

{ #category : 'rendering' }
OPBPMNDataObjectShape >> renderShapeDetails [
	labeled := OPRSLabeled new.
	labeled color: Color black.
	labeled shapeBuilder wrapStrategy: RSWrapStrategy new.
	labeled location below.
	labeled text: ''.
	roassalShape @ labeled.

	icon := self createTypeIconShape.
	self canvas add: icon.
	self attachIconShape
]

{ #category : 'interactions' }
OPBPMNDataObjectShape >> selectableInteraction [

	^ OPRSSelectable highlightBorderColorBlue
]

{ #category : 'accessing' }
OPBPMNDataObjectShape >> strokeColor: aColor [

	borderColor := aColor = Color black
		               ifTrue: [ Color transparent ]
		               ifFalse: [ aColor ].
	self isRendered ifFalse: [ ^ self ].
	roassalShape borderColor: borderColor.
	self updateIcon
]

{ #category : 'update' }
OPBPMNDataObjectShape >> updateIcon [
	| newIconComposite |
	icon ifNil: [ ^ self ].
	newIconComposite := self createTypeIconShape.
	icon resetChildren.
	newIconComposite children copy do: [ :eachChild |
		icon add: eachChild ].
	icon adjustToChildren.
	self updateIconPosition
]

{ #category : 'rendering' }
OPBPMNDataObjectShape >> updateIconPosition [
	icon ifNil: [ ^ self ].
	RSLocation new move: icon on: self roassalShape
]

{ #category : 'rendering' }
OPBPMNDataObjectShape >> updateRenderFromModel [
	labeled ifNotNil: [
		labeled text: (self modelElement name ifNil: [ '' ]) ].
	self updateIcon.
	super updateRenderFromModel.
	roassalShape signalUpdate
]

{ #category : 'rendering' }
OPBPMNDataObjectShape >> updateRenderFromSelf [
	self isRendered ifFalse: [ ^ self ].
	roassalShape color: self color.
	self updateIcon.
	super updateRenderFromSelf
]
