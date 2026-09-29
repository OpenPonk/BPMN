"
A diagram command that executes the hierarchical automatic layout algorithm on the active BPMN diagram elements.
"
Class {
	#name : 'OPBPMNLayoutCommand',
	#superclass : 'OPLayoutDiagramCommand',
	#category : 'OpenPonk-BPMN-Commands',
	#package : 'OpenPonk-BPMN',
	#tag : 'Commands'
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
