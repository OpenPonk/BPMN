Class {
	#name : #OPBPMNDataObjectShape,
	#superclass : #OPShape,
	#instVars : [
		'icon',
		'borderColor'
	],
	#category : #'OpenPonk-BPMN-DiagramElements'
}

{ #category : #update }
OPBPMNDataObjectShape >> borderColor [

	^ borderColor
]

{ #category : #update }
OPBPMNDataObjectShape >> borderColor: aColor [

	aColor = Color black
		ifTrue: [ borderColor := Color transparent ]
		ifFalse: [ borderColor := aColor ]
]

{ #category : #update }
OPBPMNDataObjectShape >> color [

	^ self stylePropertyNamed: #fillColor ifAbsent: [ Color transparent ]
]

{ #category : #update }
OPBPMNDataObjectShape >> color: aColor [

	^ self stylePropertyNamed: #fillColor put: aColor
]

{ #category : #update }
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

{ #category : #update }
OPBPMNDataObjectShape >> initialize [ 
	super initialize.
	borderColor := Color transparent
]

{ #category : #update }
OPBPMNDataObjectShape >> renderBasicShape [

	^ self createRoassalShape model: self
]

{ #category : #update }
OPBPMNDataObjectShape >> renderShapeDetails [

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
	self roassalShape
		when: RSShapeRemovedEvent
		do: [ icon remove ]
		for: self.

	roassalShape @ OPRSSelectionDraggable.
	selectable := OPRSSelectable new.
	self setupHighlight: selectable.
	roassalShape @ selectable
]

{ #category : #update }
OPBPMNDataObjectShape >> setupHighlight: aHighlightable [

	aHighlightable highlightBorderColor: Color blue
]

{ #category : #update }
OPBPMNDataObjectShape >> typeIconForModel [

	^ self modelElement typeIconFor: self modelElement type
]

{ #category : #update }
OPBPMNDataObjectShape >> updateIcon [
	icon form: self typeIconForModel.
]

{ #category : #update }
OPBPMNDataObjectShape >> updateRenderFromModel [

	(roassalShape propertyAt: #RSLabeled) text: self modelElement name.
	self updateIcon.
	super updateRenderFromModel.
	
	roassalShape signalUpdate
]

{ #category : #update }
OPBPMNDataObjectShape >> updateRenderFromSelf [

	self isRendered ifFalse: [ ^ self ].
	roassalShape color: self color.
	roassalShape borderColor: self borderColor.
	super updateRenderFromSelf
]
