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
	super buildEditorForm: aForm.
	(aForm addDroplist: 'Marker')
		items:
			#( #None #MarkerParallel #MarkerSequential #MarkerLoop #MarkerCompensation
			   #MarkerAdhoc );
		displayIcon: [ :type | self model typeIconFor: type ];
		display: [ :type | type asString ];
		selectItem: self model type;
		whenSelectedItemChangedDo: [ :newValue |
			self model type: newValue.
			self modelChanged ].
	(aForm addCheckbox: 'Is Call Activity?')
		state: self model isCallActivity;
		whenChangedDo: [ :val |
			self model isCallActivity: val.
			self modelChanged ].
	self modelChanged
]

{ #category : 'accessing' }
OPBPMNCollapsedSubProcessViewModel >> icon [ ^ OPBPMNIcon current subProcessCollapsed
]
