Class {
	#name : 'OPBPMNLayoutCommand',
	#superclass : 'OPLayoutDiagramCommand',
	#category : 'OpenPonk-BPMN-ViewModels',
	#package : 'OpenPonk-BPMN',
	#tag : 'ViewModels'
}

{ #category : 'accessing' }
OPBPMNLayoutCommand >> defaultMenuItemName [
	"Answers the display name of the layout command in the canvas toolbar menu."

	^ 'Process Flow'
]

{ #category : 'execution' }
OPBPMNLayoutCommand >> execute [
	"Executes default hierarchical layout on the diagram layouter."

	layouter defaultLayout
]
