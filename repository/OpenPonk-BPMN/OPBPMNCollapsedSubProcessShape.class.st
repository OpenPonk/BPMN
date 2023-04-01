Class {
	#name : #OPBPMNCollapsedSubProcessShape,
	#superclass : #OPBPMNNodeShape,
	#instVars : [
		'subprocessIcon',
		'border'
	],
	#category : #'OpenPonk-BPMN-DiagramElements'
}

{ #category : #'ston-core' }
OPBPMNCollapsedSubProcessShape class >> stonAllInstVarNames [

	"Override to encode my instances using a custom set of instance variables or to define their order."

	^ super stonAllInstVarNames copyWithoutAll: #( #icon )
]

{ #category : #connecting }
OPBPMNCollapsedSubProcessShape >> createBorder [

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

{ #category : #connecting }
OPBPMNCollapsedSubProcessShape >> createRoassalShape [
	^ RSBox new
		extent: 85@55;
		border: border;
		cornerRadius: 10;
		yourself
	
]

{ #category : #connecting }
OPBPMNCollapsedSubProcessShape >> initialize [
	super initialize.
	self createBorder.
	
]

{ #category : #connecting }
OPBPMNCollapsedSubProcessShape >> renderShapeDetails [

	| label selectable |
	label := RSLabeled new.
	label location middle.
	label shapeBuilder labelShape color: Color black.
	roassalShape addInteraction: label.
	subprocessIcon := RSBitmap new
		        form: (self typeIconFor: OPBPMNNodeType MarkerSubProcess);
		        yourself.
	icon := RSBitmap new
		        form: self typeIconForModel;
		        yourself.
	self canvas add: subprocessIcon.
	self canvas add: icon.
	RSLocation new
		stick: icon on: self roassalShape;
		offset: -16 @ 18.
	self roassalShape when: RSShapeRemovedEvent do: [ icon remove ].
	RSLocation new
		stick: subprocessIcon on: self roassalShape;
		offset: 0 @ 18.
	self roassalShape when: RSShapeRemovedEvent do: [ subprocessIcon remove ].
	self color: (Color fromHexString: 'f2f2f2').

	roassalShape @ OPRSSelectionDraggable.
	selectable := OPRSSelectable new.
	self setupHighlight: selectable.
	roassalShape @ selectable
]

{ #category : #connecting }
OPBPMNCollapsedSubProcessShape >> typeIconFor: aType [
	aType = OPBPMNNodeType None  
		ifTrue: [ ^ OPBPMNIcon current activityNone ].
	aType = OPBPMNNodeType MarkerSubProcess  
		ifTrue: [ ^ OPBPMNIcon current markerSubProcess  ].
	aType = OPBPMNNodeType MarkerParallel 
		ifTrue: [ ^ OPBPMNIcon current markerParallel ].
	aType = OPBPMNNodeType MarkerSequential 
		ifTrue: [ ^ OPBPMNIcon current markerSequential ].
	aType = OPBPMNNodeType MarkerLoop
		ifTrue: [ ^ OPBPMNIcon current markerLoop ].
	aType = OPBPMNNodeType MarkerCompensation 
		ifTrue: [ ^ OPBPMNIcon current markerCompensation ].
	aType = OPBPMNNodeType MarkerAdhoc 
		ifTrue: [ ^ OPBPMNIcon current markerAdhoc ]
]

{ #category : #connecting }
OPBPMNCollapsedSubProcessShape >> updateRenderFromModel [

	(roassalShape propertyAt: #RSLabeled) text: self modelElement name.
	self updateIcon.
	self createBorder.
	super updateRenderFromModel.

	roassalShape signalUpdate
]
