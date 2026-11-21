"
I am the ViewModel for BPMN TextAnnotations. I bridge the underlying annotation text model with the UI diagram representation and property forms.
"
Class {
	#name : 'OPBPMNAnnotationViewModel',
	#superclass : 'OPModelObjectViewModel',
	#category : 'OpenPonk-BPMN-ViewModels',
	#package : 'OpenPonk-BPMN',
	#tag : 'ViewModels'
}

{ #category : 'accessing' }
OPBPMNAnnotationViewModel class >> modelClass [ ^ OPBPMNAnnotationModel
]

{ #category : 'forms' }
OPBPMNAnnotationViewModel >> buildEditorForm: aForm [

	aForm bindText: 'Text' property: #text
]

{ #category : 'accessing' }
OPBPMNAnnotationViewModel >> childrenModels [
	"Answers contained elements and connected associations belonging to this annotation."
	^ self model elements asArray , self model associations asArray
]

{ #category : 'accessing' }
OPBPMNAnnotationViewModel >> icon [ ^ Smalltalk ui icons iconNamed: #smallLeftFlush
]

{ #category : 'printing' }
OPBPMNAnnotationViewModel >> nameOfModel [

	^ self model text ifNil: [ '' ]
]
