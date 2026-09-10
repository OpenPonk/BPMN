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

	| com b1 |
	com := RSComposite new.
	b1 := RSBox new
		      width: 50;
		      height: 50;
				border: (RSBorder new
							width: 1;
				          color: Color transparent);
		      color: Color transparent.
	"bitmap := RSBitmap new
		        form: self typeIconForModel.
		
	com add: bitmap."
	com add: b1.
	com adjustToChildren.
	^ com
]

{ #category : 'initialization' }
OPBPMNDataObjectShape >> initialize [

	super initialize.
	borderColor := Color transparent
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

	icon := RSBitmap new
		form: self typeIconForModel;
		yourself.
	self canvas add: icon.
	RSLocation new stick: icon on: self roassalShape
]

{ #category : 'interactions' }
OPBPMNDataObjectShape >> selectableInteraction [

	^ OPRSSelectable highlightBorderColorBlue
]

{ #category : 'update' }
OPBPMNDataObjectShape >> strokeColor: aColor [

	borderColor := aColor = Color black
		               ifTrue: [ Color transparent ]
		               ifFalse: [ aColor ]
]

{ #category : 'update' }
OPBPMNDataObjectShape >> typeIconForModel [

	^ self modelElement typeIconFor: self modelElement type
]

{ #category : 'update' }
OPBPMNDataObjectShape >> updateIcon [
	icon form: self typeIconForModel.
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
	roassalShape borderColor: self borderColor.
	super updateRenderFromSelf
]
