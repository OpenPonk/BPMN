Class {
	#name : #OPBPMNPlugin,
	#superclass : #OPPlugin,
	#category : #'OpenPonk-BPMN-Adapters'
}

{ #category : #toolbar }
OPBPMNPlugin class >> exportPackage: aPackage [

	StFBSaveFileDialog new
		title: 'Choose a BPMN file to export to';
		okAction: [ :file | 
			file
				ensureDelete;
				writeStreamDo: [ :stream | 
					stream << (OPBPMNXMLWriter toString: aPackage) ].
			UIManager default
				inform: (String streamContents: [ :s | 
						 s << 'Exported to ' << file pathString.
						 s
							 cr;
							 cr.
						 s << 'Click to open location' ])
				actionOnClick: [ file openInOSFileBrowser ] ];
		extensions: #( bpmn xml ) named: 'BPMN XML files';
		open
]

{ #category : #accessing }
OPBPMNPlugin class >> toolbarMenu: aBuilder [
	<opEditorToolbarMenu: #OPBPMNPlugin>
	(aBuilder item: 'Export as XML...')
		"icon: (self iconNamed: #help);"
		action: [ self exportPackage: aBuilder model diagramController ]
]

{ #category : #accessing }
OPBPMNPlugin >> diagramControllerClass [
	^ OPBPMNDiagramController
]

{ #category : #accessing }
OPBPMNPlugin >> icon [
	^ OPBPMNIcon current logo
]

{ #category : #accessing }
OPBPMNPlugin >> layouterClass [
	"Create your own subclass of OPLayouter or use OPNoLayouter which does nothing"
	^ OPBPMNLayouter
]

{ #category : #accessing }
OPBPMNPlugin >> modelClass [
	^ OPBPMNModel
]

{ #category : #accessing }
OPBPMNPlugin >> modelSerializerClass [
	^ OPStonModelSerializer
]

{ #category : #accessing }
OPBPMNPlugin >> name [
	^ 'BPMN'
]

{ #category : #accessing }
OPBPMNPlugin >> supportsHidingElements [
	^ true
]
