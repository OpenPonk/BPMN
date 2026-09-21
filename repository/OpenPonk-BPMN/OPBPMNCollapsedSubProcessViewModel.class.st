"
I map the underlying BPMN Collapsed SubProcess model to its UI representation and Magritte property forms.
"
Class {
	#name : 'OPBPMNCollapsedSubProcessViewModel',
	#superclass : 'OPBPMNSemanticNodeViewModel',
	#category : 'OpenPonk-BPMN-ViewModels',
	#package : 'OpenPonk-BPMN',
	#tag : 'ViewModels'
}

{ #category : 'accessing' }
OPBPMNCollapsedSubProcessViewModel class >> modelClass [ ^ OPBPMNCollapsedSubProcessModel
]

{ #category : 'forms' }
OPBPMNCollapsedSubProcessViewModel >> buildEditorForm: aForm [

	| droplist |
	super buildEditorForm: aForm.
	droplist := aForm
		bindDroplist: 'Marker'
		property: #type
		items:
			#( #None #MarkerParallel #MarkerSequential #MarkerLoop #MarkerCompensation
			   #MarkerAdhoc ).
	droplist displayIcon: [ :eachMarker | self model typeIconFor: eachMarker ].
	droplist display: [ :eachMarker | eachMarker asString ].
	aForm bindCheckbox: 'Is Call Activity?' property: #isCallActivity
]

{ #category : 'accessing' }
OPBPMNCollapsedSubProcessViewModel >> icon [ ^ OPBPMNIcon current subProcessCollapsed
]

{ #category : 'testing' }
OPBPMNCollapsedSubProcessViewModel >> isNameMultiline [
	^ true
]
