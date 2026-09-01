"
I am a unit test class verifying the behavior of OPBPMNMessageFlowController, focusing on correct source and target assignments for message flows.
"
Class {
	#name : 'OPBPMNMessageFlowControllerTest',
	#superclass : 'OPBPMNAbstractFlowControllerTest',
	#category : 'OpenPonk-BPMN-Tests',
	#package : 'OpenPonk-BPMN',
	#tag : 'Tests'
}

{ #category : 'constants' }
OPBPMNMessageFlowControllerTest class >> diagramElementClass [

	^ OPBPMNMessageFlowShape 
]

{ #category : 'constants' }
OPBPMNMessageFlowControllerTest >> controllerClass [
	^ OPBPMNMessageFlowController
]

{ #category : 'constants' }
OPBPMNMessageFlowControllerTest >> modelClass [
	^ OPBPMNMessageFlowModel 
]

{ #category : 'constants' }
OPBPMNMessageFlowControllerTest >> sourceControllerClass [
	^ OPBPMNPoolController  
]

{ #category : 'constants' }
OPBPMNMessageFlowControllerTest >> sourceModelClass [
	^ OPBPMNPoolModel 
]
