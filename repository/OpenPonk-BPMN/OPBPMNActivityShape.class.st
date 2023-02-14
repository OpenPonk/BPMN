Class {
	#name : #OPBPMNActivityShape,
	#superclass : #OPBPMNNodeShape,
	#category : #'OpenPonk-BPMN-DiagramElements'
}

{ #category : #'ston-core' }
OPBPMNActivityShape class >> stonAllInstVarNames [

	"Override to encode my instances using a custom set of instance variables or to define their order."

	^ super stonAllInstVarNames copyWithoutAll: #( #icon )
]

{ #category : #rendering }
OPBPMNActivityShape >> createRoassalShape [
	^ RSBox new
		extent: 85@55;
		border: (RSBorder new
		color: (Color black);
		width: 1);
		cornerRadius: 10;
		yourself
	
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

	roassalShape @ OPRSSelectionDraggable.
	selectable := OPRSSelectable new.
	self setupHighlight: selectable.
	roassalShape @ selectable
]

{ #category : #rendering }
OPBPMNActivityShape >> typeIconFor: aType [
	aType = OPBPMNNodeType Service
		ifTrue: [ ^ OPBPMNIcon current activityService ].
	aType = OPBPMNNodeType User
		ifTrue: [ ^ OPBPMNIcon current activityUser ].
	aType = OPBPMNNodeType Manual
		ifTrue: [ ^ OPBPMNIcon current activityManual ].
			aType = OPBPMNNodeType Send
		ifTrue: [ ^ OPBPMNIcon current activitySend ].
			aType = OPBPMNNodeType Receive
		ifTrue: [ ^ OPBPMNIcon current activityReceive ].
			aType = OPBPMNNodeType None
		ifTrue: [ ^ OPBPMNIcon current activityNone ]
]
