Class {
	#name : #OPBPMNBoundaryEventShape,
	#superclass : #OPBPMNNodeShape,
	#category : #'OpenPonk-BPMN-DiagramElements'
}

{ #category : #connecting }
OPBPMNBoundaryEventShape >> createRoassalShape [

	^ RSCircle new
		  size: 39;
		  borderColor: Color black;
		  yourself
]

{ #category : #connecting }
OPBPMNBoundaryEventShape >> renderShapeDetails [

	| label selectable innerCircle |
	label := RSLabeled new.
	label location below offset: 0 @ 2.
	label shapeBuilder labelShape color: Color black.
	roassalShape addInteraction: label.
	self color: (Color fromHexString: 'fdd2d2').
	icon := RSBitmap new
		        form: self typeIconForModel;
		        yourself.
	self canvas add: icon.
	RSLocation new stick: icon on: self roassalShape.
	self roassalShape when: RSShapeRemovedEvent do: [ icon remove ].

	innerCircle := RSCircle new
		               size: 31;
		               borderColor: Color black;
		               color: Color transparent;
		               yourself.
	self canvas add: innerCircle.
	RSLocation new stick: innerCircle on: self roassalShape.
	self roassalShape
		when: RSShapeRemovedEvent
		do: [ innerCircle remove ].

	"roassalShape @ OPRSSelectionDraggable."
	selectable := OPRSSelectable new.
	self setupHighlight: selectable.
	roassalShape @ selectable
]

{ #category : #connecting }
OPBPMNBoundaryEventShape >> typeIconFor: aType [

	aType = OPBPMNNodeType Receive ifTrue: [ 
		^ OPBPMNIcon current activityReceiveSquare ].
	aType = OPBPMNNodeType Timer ifTrue: [ 
		^ OPBPMNIcon current eventTimer ].
	aType = OPBPMNNodeType Escalation ifTrue: [ 
		^ OPBPMNIcon current eventEscalation ].
	aType = OPBPMNNodeType Conditional ifTrue: [ 
		^ OPBPMNIcon current eventCondition ].
	aType = OPBPMNNodeType Error ifTrue: [ 
		^ OPBPMNIcon current eventError ].
	aType = OPBPMNNodeType Cancel ifTrue: [ 
		^ OPBPMNIcon current eventCancel ].
	aType = OPBPMNNodeType Compensation ifTrue: [ 
		^ OPBPMNIcon current eventCompensation ].
	aType = OPBPMNNodeType Signal ifTrue: [ 
		^ OPBPMNIcon current eventSignal ].
	aType = OPBPMNNodeType Multiple ifTrue: [ 
		^ OPBPMNIcon current eventMultiple ].
	aType = OPBPMNNodeType ParallelMultiple ifTrue: [ 
		^ OPBPMNIcon current eventParallelMultiple ].
	aType = OPBPMNNodeType CatchCompensation ifTrue: [ 
		^ OPBPMNIcon current eventCatchCompensation ]
]

{ #category : #connecting }
OPBPMNBoundaryEventShape >> updateRenderFromSelf [

	self isRendered ifFalse: [ ^ self ].
	roassalShape color: self color.
	self modelElement subscribeDiagram ifNotNil: [ 
		roassalShape translateTo: 
		self modelElement subscribeDiagram position ].

	super updateRenderFromSelf
]
