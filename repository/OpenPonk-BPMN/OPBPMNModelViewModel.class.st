"
View model for the root BPMN model, managing its UI representation and exposing its child elements to diagram controllers and workbench views.
"
Class {
	#name : 'OPBPMNModelViewModel',
	#superclass : 'OPModelObjectViewModel',
	#category : 'OpenPonk-BPMN-ViewModels',
	#package : 'OpenPonk-BPMN',
	#tag : 'ViewModels'
}

{ #category : 'accessing' }
OPBPMNModelViewModel class >> commonModelClassPrefix [

	^ 'OPBPMN'
]

{ #category : 'accessing' }
OPBPMNModelViewModel class >> modelClass [ ^ OPBPMNModel
]

{ #category : 'accessing' }
OPBPMNModelViewModel >> childrenModels [ ^ self model nodes
]

{ #category : 'accessing' }
OPBPMNModelViewModel >> icon [ ^ OPBPMNIcon current logo
]

{ #category : 'accessing' }
OPBPMNModelViewModel >> modelRootViewModel [

	^ self
]
