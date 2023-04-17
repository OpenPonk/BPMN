Class {
	#name : #OPBPMNNodeShape,
	#superclass : #OPShape,
	#instVars : [
		'icon',
		'borderColor'
	],
	#category : #'OpenPonk-BPMN-DiagramElements'
}

{ #category : #'ston-core' }
OPBPMNNodeShape class >> stonAllInstVarNames [

	"Override to encode my instances using a custom set of instance variables or to define their order."

	^ super stonAllInstVarNames copyWithoutAll: #( #icon )
]

{ #category : #hooks }
OPBPMNNodeShape >> borderColor [

	^ borderColor
]

{ #category : #hooks }
OPBPMNNodeShape >> borderColor: aColor [

	borderColor := aColor
]

{ #category : #hooks }
OPBPMNNodeShape >> color [

	^ self stylePropertyNamed: #fillColor ifAbsent: [ Color transparent ]
]

{ #category : #hooks }
OPBPMNNodeShape >> color: aColor [

	^ self stylePropertyNamed: #fillColor put: aColor
]

{ #category : #connecting }
OPBPMNNodeShape >> createRoassalShape [
	^ self subclassResponsibility 
	
]

{ #category : #hooks }
OPBPMNNodeShape >> initialize [ 
	super initialize.
	borderColor := Color black
]

{ #category : #hooks }
OPBPMNNodeShape >> renderBasicShape [

	^ self createRoassalShape model: self
]

{ #category : #hooks }
OPBPMNNodeShape >> renderShapeDetails [

	| label selectable |
	label := RSLabeled new.
	label location below.
	label shapeBuilder labelShape color: Color black.
	roassalShape addInteraction: label.

	icon := RSBitmap new
		        form: self typeIconForModel;
		        yourself.
	self canvas add: icon.
	RSLocation new stick: icon on: self roassalShape.
	self roassalShape when: RSShapeRemovedEvent do: [ icon remove ].

	"roassalShape @ OPRSSelectionDraggable.
	selectable := OPRSSelectable new.
	self setupHighlight: selectable.
	roassalShape @ selectable"
		selectable := OPRSSelectable new.
	selectable highlightBorderColor: Color blue.
	roassalShape @ selectable.
	roassalShape @ OPRSSelectionDraggable

]

{ #category : #hooks }
OPBPMNNodeShape >> setupHighlight: aHighlightable [

	aHighlightable highlightBorderColor: Color blue
]

{ #category : #hooks }
OPBPMNNodeShape >> typeIconForModel [

	^ self modelElement typeIconFor: self modelElement type
]

{ #category : #updating }
OPBPMNNodeShape >> updateIcon [
	icon form: self typeIconForModel.
]

{ #category : #updating }
OPBPMNNodeShape >> updateRenderFromModel [

	(roassalShape propertyAt: #RSLabeled) text: self modelElement name.
	self updateIcon.
	super updateRenderFromModel.

	roassalShape signalUpdate
]

{ #category : #updating }
OPBPMNNodeShape >> updateRenderFromSelf [

	self isRendered ifFalse: [ ^ self ].
	roassalShape color: self color.
	roassalShape borderColor: self borderColor.
	
	super updateRenderFromSelf
]
