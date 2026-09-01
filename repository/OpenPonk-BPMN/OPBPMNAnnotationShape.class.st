"
I render a BPMN Text Annotation as a Roassal bound node, drawing the characteristic open bracket boundary and accommodating text bounds.
"
Class {
	#name : 'OPBPMNAnnotationShape',
	#superclass : 'OPBoundNode',
	#instVars : [
		'labeled',
		'borderLine',
		'lastText'
	],
	#category : 'OpenPonk-BPMN-DiagramElements',
	#package : 'OpenPonk-BPMN',
	#tag : 'DiagramElements'
}

{ #category : 'update' }
OPBPMNAnnotationShape >> accomodateText [

	self roassalShape extent:
		(labeled labelShape extent + (self textPadding * 2) max:
			 self minExtent)
]

{ #category : 'reacting' }
OPBPMNAnnotationShape >> associationCreated: anAssociation [

	anAssociation
		roassalShapeWhen: RSExtentChangedEvent
		send: #updateBorder
		to: self.
	anAssociation
		when: OPDiagramElementRenderRemovedAnnouncement
		send: #updateBorder
		to: self.
	self updateBorder
]

{ #category : 'accessing' }
OPBPMNAnnotationShape >> attachedShapes [

	^ {
		 borderLine.
		  (labeled ifNotNil: [ :l | l labelShape ]) }
]

{ #category : 'rendering' }
OPBPMNAnnotationShape >> minExtent [

	^ self visibleBorderWidth + 2 @ 30
]

{ #category : 'removing' }
OPBPMNAnnotationShape >> removeRender [

	sourceEdges , targetEdges do: [ :eachEdge |
			eachEdge roassalShape ifNotNil: [ :existingRoassalShape |
				existingRoassalShape announcer unsubscribe: self ] ].
	super removeRender
]

{ #category : 'rendering' }
OPBPMNAnnotationShape >> renderBasicShape [
	"should render a simple shape without using any modelElement info and any advanced shape complexity"

	^ RSBox new
		  color: Color transparent;
		  borderColor: Color transparent;
		  yourself
]

{ #category : 'rendering' }
OPBPMNAnnotationShape >> renderShapeDetails [

	borderLine := RSPolyline new
		              color: Color black;
		              controlPointsController:
			              OPBPMNAnnotationCPController new;
		              from: roassalShape;
		              to: roassalShape;
		              model: self;
		              yourself.

	roassalShape canvas add: borderLine.
	roassalShape pushFront.

	labeled := OPRSLabeled new.
	labeled fontSize: RSLabel defaultFontSize - 1.
	labeled model: self.
	labeled color: Color black.
	labeled shapeBuilder wrapStrategy: RSWrapStrategy new.
	labeled text: ''.

	self roassalShape @ labeled.

	labeled location
		inner;
		left;
		middle;
		offset: self textPadding @ 0.

	roassalShape
		when: RSPositionChangedEvent
		do: [ self updateAttachedElements ]
		for: self.
	roassalShape
		when: RSExtentChangedEvent
		do: [ self updateBorder ]
		for: self.

	self updateAttachedElements
]

{ #category : 'interactions' }
OPBPMNAnnotationShape >> selectableInteraction [

	^ OPRSSelectable highlightBorderColorBlue
]

{ #category : 'creating - subelements' }
OPBPMNAnnotationShape >> textPadding [

	^ 5
]

{ #category : 'rendering' }
OPBPMNAnnotationShape >> updateAttachedElements [

	self accomodateText.
	self updateBorder
]

{ #category : 'update' }
OPBPMNAnnotationShape >> updateBorder [

	borderLine update
]

{ #category : 'rendering' }
OPBPMNAnnotationShape >> updateRenderFromModel [

	lastText = self modelElement text ifTrue: [
		^ super updateRenderFromModel ].
	
	lastText := self modelElement text.
	labeled text: lastText.
	
	self accomodateText.
	super updateRenderFromModel.
	roassalShape signalUpdate
]

{ #category : 'hooks' }
OPBPMNAnnotationShape >> visibleBorderWidth [

	^ 20
]
