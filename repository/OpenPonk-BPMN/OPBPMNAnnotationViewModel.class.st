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

{ #category : 'accessing' }
OPBPMNAnnotationViewModel >> childrenModels [ ^ self model elements
]

{ #category : 'forms' }
OPBPMNAnnotationViewModel >> descriptionName [

	<magritteDescription>
	| accessor |
	accessor := MAPluggableAccessor
		            read: [ :me | me model text ]
		            write: [ :me :newValue | 
			            me model text: newValue.
			            self modelChanged ].
	^ MAMemoDescription new
		  accessor: accessor;
		  label: 'Text';
		  priority: 1;
		  yourself
]

{ #category : 'accessing' }
OPBPMNAnnotationViewModel >> icon [ ^ Smalltalk ui icons iconNamed: #smallLeftFlush
]
