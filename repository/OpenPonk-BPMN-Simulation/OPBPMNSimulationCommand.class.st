"
A model command that launches the discrete token simulator for the active BPMN collaboration diagram.
"
Class {
	#name : 'OPBPMNSimulationCommand',
	#superclass : 'OPBPMNCommand',
	#category : 'OpenPonk-BPMN-Simulation-Simulation',
	#package : 'OpenPonk-BPMN-Simulation',
	#tag : 'Simulation'
}

{ #category : 'activation' }
OPBPMNSimulationCommand class >> modelMenuActivation [
	<classAnnotation>
	^ OPModelMenuActivation
		byItemOf: OPModelBasicMenuGroup
		order: 10
		for: OPEditor
]

{ #category : 'accessing' }
OPBPMNSimulationCommand >> defaultMenuIconName [
	"Answers the icon name for the simulation command."
	^ #glamorousSpawn
]

{ #category : 'accessing' }
OPBPMNSimulationCommand >> defaultMenuItemName [
	"Answers the display name of the simulation command."
	^ 'Simulation'
]

{ #category : 'execution' }
OPBPMNSimulationCommand >> execute [
	"Opens the BPMN simulation interface for the active diagram controller."
	OPBPMNSimulationGUI diagramController: self diagramController
]
