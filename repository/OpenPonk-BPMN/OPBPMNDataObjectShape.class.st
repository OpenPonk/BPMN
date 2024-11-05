Class {
	#name : 'OPBPMNDataObjectShape',
	#superclass : 'OPBoundNode',
	#instVars : [
		'icon',
		'borderColor'
	],
	#category : 'OpenPonk-BPMN-Shapes',
	#package : 'OpenPonk-BPMN',
	#tag : 'Shapes'
}

{ #category : 'removing' }
OPBPMNDataObjectShape >> attachedShapes [

	^ super attachedShapes , { icon }
]

{ #category : 'update' }
OPBPMNDataObjectShape >> borderColor [

	^ borderColor
]

{ #category : 'update' }
OPBPMNDataObjectShape >> borderColor: aColor [

	aColor = Color black
		ifTrue: [ borderColor := Color transparent ]
		ifFalse: [ borderColor := aColor ]
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

{ #category : 'update' }
OPBPMNDataObjectShape >> initialize [ 
	super initialize.
	borderColor := Color transparent
]

{ #category : 'removing' }
OPBPMNDataObjectShape >> removeRender [

	super removeRender.
	icon := nil
]

{ #category : 'update' }
OPBPMNDataObjectShape >> renderBasicShape [

	^ self createRoassalShape model: self
]

{ #category : 'update' }
OPBPMNDataObjectShape >> renderShapeDetails [

	| label |
	label := RSLabeled new.
	label location below.
	label shapeBuilder labelShape color: Color black.
	roassalShape addInteraction: label.

	icon := RSBitmap new
		        form: self typeIconForModel;
		        yourself.
	self canvas add: icon.
	RSLocation new stick: icon on: self roassalShape
]

{ #category : 'update' }
OPBPMNDataObjectShape >> selectableInteraction [

	^ OPRSSelectable highlightBorderColorBlue
]

{ #category : 'update' }
OPBPMNDataObjectShape >> shouldBePositionableByUser [

	^ true
]

{ #category : 'update' }
OPBPMNDataObjectShape >> typeIconForModel [

	^ self modelElement typeIconFor: self modelElement type
]

{ #category : 'update' }
OPBPMNDataObjectShape >> updateIcon [
	icon form: self typeIconForModel.
]

{ #category : 'update' }
OPBPMNDataObjectShape >> updateRenderFromModel [

	(roassalShape propertyAt: #RSLabeled) text: self modelElement name.
	self updateIcon.
	super updateRenderFromModel.
	
	roassalShape signalUpdate
]

{ #category : 'update' }
OPBPMNDataObjectShape >> updateRenderFromSelf [

	self isRendered ifFalse: [ ^ self ].
	roassalShape color: self color.
	roassalShape borderColor: self borderColor.
	super updateRenderFromSelf
]
