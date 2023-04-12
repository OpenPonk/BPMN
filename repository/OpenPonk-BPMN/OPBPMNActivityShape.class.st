Class {
	#name : #OPBPMNActivityShape,
	#superclass : #OPBPMNNodeShape,
	#instVars : [
		'border'
	],
	#category : #'OpenPonk-BPMN-DiagramElements'
}

{ #category : #'ston-core' }
OPBPMNActivityShape class >> stonAllInstVarNames [

	"Override to encode my instances using a custom set of instance variables or to define their order."

	^ super stonAllInstVarNames copyWithoutAll: #( #icon )
]

{ #category : #rendering }
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

{ #category : #rendering }
OPBPMNActivityShape >> createRoassalShape [
	^ RSBox new
		extent: 85@55;
		border: border;
		cornerRadius: 10;
		yourself
	
]

{ #category : #rendering }
OPBPMNActivityShape >> initialize [
	super initialize.
	self createBorder.
	
]

{ #category : #rendering }
OPBPMNActivityShape >> renderShapeDetails [

	| label selectable |
	label := RSLabeled new.
	label location middle.
	label shapeBuilder labelShape color: Color black.
	roassalShape addInteraction: label.

	icon := RSBitmap new
		        form: self typeIconForModel;
		        yourself.
	self canvas add: icon.
	RSLocation new
		stick: icon on: self roassalShape;
		offset: -28 @ -16.
	self roassalShape when: RSShapeRemovedEvent do: [ icon remove ].

	self color: (Color fromHexString: 'f2f2f2').
"TODO for what are good bounds?????"
	self bounds: nil.
	roassalShape @ OPRSSelectionDraggable.
	selectable := OPRSSelectable new.
	self setupHighlight: selectable.
	roassalShape @ selectable
]

{ #category : #rendering }
OPBPMNActivityShape >> updateRenderFromModel [

	(roassalShape propertyAt: #RSLabeled) text: self modelElement name.
	self updateIcon.
	self createBorder.
	super updateRenderFromModel.

	roassalShape signalUpdate
]
