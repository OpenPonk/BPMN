Class {
	#name : 'OPBPMNNodeShape',
	#superclass : 'OPBoundNode',
	#instVars : [
		'icon',
		'borderColor'
	],
	#category : 'OpenPonk-BPMN-DiagramElements',
	#package : 'OpenPonk-BPMN',
	#tag : 'DiagramElements'
}

{ #category : 'ston-core' }
OPBPMNNodeShape class >> stonAllInstVarNames [

	"Override to encode my instances using a custom set of instance variables or to define their order."

	^ super stonAllInstVarNames copyWithoutAll: #( #icon )
]

{ #category : 'reacting' }
OPBPMNNodeShape >> associationCreated: anAssociation [

	"do nothing"
]

{ #category : 'accessing' }
OPBPMNNodeShape >> attachedShapes [

	^ super attachedShapes , { icon }
]

{ #category : 'accessing' }
OPBPMNNodeShape >> borderColor [

	^ borderColor
]

{ #category : 'accessing' }
OPBPMNNodeShape >> color [

	^ self stylePropertyNamed: #fillColor ifAbsent: [ Color transparent ]
]

{ #category : 'accessing' }
OPBPMNNodeShape >> color: aColor [

	^ self stylePropertyNamed: #fillColor put: aColor
]

{ #category : 'connecting' }
OPBPMNNodeShape >> createRoassalShape [
	^ self subclassResponsibility 
	
]

{ #category : 'initialization' }
OPBPMNNodeShape >> initialize [ 
	super initialize.
	borderColor := Color black
]

{ #category : 'removing' }
OPBPMNNodeShape >> removeRender [

	super removeRender.
	icon := nil
]

{ #category : 'rendering' }
OPBPMNNodeShape >> renderBasicShape [

	^ self createRoassalShape model: self
]

{ #category : 'rendering' }
OPBPMNNodeShape >> renderShapeDetails [

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

{ #category : 'interactions' }
OPBPMNNodeShape >> selectableInteraction [

	^ OPRSSelectable highlightBorderColorBlue
]

{ #category : 'accessing' }
OPBPMNNodeShape >> strokeColor: aColor [

	borderColor := aColor
]

{ #category : 'connecting' }
OPBPMNNodeShape >> typeIconForModel [

	^ self modelElement typeIconFor: self modelElement type
]

{ #category : 'update' }
OPBPMNNodeShape >> updateIcon [
	icon form: self typeIconForModel.
]

{ #category : 'rendering' }
OPBPMNNodeShape >> updateRenderFromModel [

	(roassalShape propertyAt: #RSLabeled) text: self modelElement name.
	self updateIcon.
	super updateRenderFromModel.

	roassalShape signalUpdate
]

{ #category : 'roassal' }
OPBPMNNodeShape >> updateRenderFromSelf [

	self isRendered ifFalse: [ ^ self ].
	roassalShape color: self color.
	roassalShape borderColor: self borderColor.
	
	super updateRenderFromSelf
]
