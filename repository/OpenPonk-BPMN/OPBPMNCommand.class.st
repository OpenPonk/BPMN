"
An abstract base class for Commander 1 model commands executed within a BPMN collaboration editor.
"
Class {
	#name : 'OPBPMNCommand',
	#superclass : 'OPModelCommand',
	#category : 'OpenPonk-BPMN-Commands',
	#package : 'OpenPonk-BPMN',
	#tag : 'Commands'
}

{ #category : 'testing' }
OPBPMNCommand class >> canBeExecutedInEditor: anEditor [
	"Answers true if the active editor plugin is BPMN."
	^ anEditor plugin isKindOf: OPBPMNPlugin
]

{ #category : 'testing' }
OPBPMNCommand class >> isAbstract [
	"Answers true if this is the abstract root of BPMN model commands."
	^ self = OPBPMNCommand
]
