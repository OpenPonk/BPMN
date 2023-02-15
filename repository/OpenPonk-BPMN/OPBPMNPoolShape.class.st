Class {
	#name : #OPBPMNPoolShape,
	#superclass : #OPShape,
	#instVars : [
		'label'
	],
	#category : #'OpenPonk-BPMN-DiagramElements'
}

{ #category : #accessing }
OPBPMNPoolShape >> color [

	^ self stylePropertyNamed: #fillColor ifAbsent: [ Color transparent ]
]

{ #category : #accessing }
OPBPMNPoolShape >> color: aColor [

	^ self stylePropertyNamed: #fillColor put: aColor
]

{ #category : #accessing }
OPBPMNPoolShape >> createRoassalShape [

	| points |
	points := { 
		          (0 @ 0).
		          (550 @ 0).
		          (550 @ 300).
		          (0 @ 300).
		          (50 @ 300).
		          (50 @ 0).
		          (0 @ 0).
		          (0 @ 300) }.
	^ RSPolygon new
		  points: points;
		  borderColor: Color black;
		  "RSBox new
		extent: 550@200;
		border: (RSBorder new
		color: (Color black);
		width: 2);
		yourself"
			  yourself
]

{ #category : #accessing }
OPBPMNPoolShape >> renderBasicShape [

	roassalShape := self createRoassalShape model: self
]

{ #category : #accessing }
OPBPMNPoolShape >> renderShapeDetails [

	| selectable "lane width" |
	label := RSLabel new
		         rotateByDegrees: -90;
		         color: Color black.
	self canvas add: label.
	RSLocation new
		stick: label on: self roassalShape;
		left;
		offset: 12 @ 0.
	self roassalShape when: RSShapeRemovedEvent do: [ label remove ].

	"lane := RSLine new
		        startPoint: 0 @ 0;
		        endPoint: 550 @ 0;
		        width: 2.
	self canvas add: lane.
	RSLocation new stick: lane on: self roassalShape.
	self roassalShape when: RSShapeRemovedEvent do: [ lane remove ].
	width := roassalShape width."
	"self roassalShape when: RSScaleChangedEvent do: [ :evt | 
		lane width: (self scaleFor: evt) * width.
		evt signalUpdate ]."

	roassalShape @ OPRSSelectionDraggable.
	roassalShape @ RSTransformable.
	selectable := OPRSSelectable new.
	self setupHighlight: selectable.
	roassalShape @ selectable
]

{ #category : #accessing }
OPBPMNPoolShape >> setupHighlight: aHighlightable [

	aHighlightable highlightBorderColor: Color blue
]

{ #category : #accessing }
OPBPMNPoolShape >> updateRenderFromModel [

	self modelElement name ifNotNil: [ 
		label text: self modelElement name ].
	super updateRenderFromModel.

	roassalShape signalUpdate
]

{ #category : #accessing }
OPBPMNPoolShape >> updateRenderFromSelf [

	self isRendered ifFalse: [ ^ self ].
	roassalShape color: self color.
	super updateRenderFromSelf
]
