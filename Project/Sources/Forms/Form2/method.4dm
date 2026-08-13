var $col; $row : Integer
var $category : cs.TodoCategoryEntity
var $selection : cs.TodoCategorySelection
var $todo : cs.TodoEntity

Case of 
    : (Form event code=On Load)
        LISTBOX SELECT ROWS(*; "List Box"; Form.selectedCategories; lk replace selection)
        OBJECT SET VISIBLE(*; "btnClose"; Form.isEditing)
        OBJECT SET VISIBLE(*; "Rectangle7"; Form.isEditing)
        OBJECT SET TITLE(*; "btnClose"; Form.closeButtonLabel)
        OBJECT SET ENABLED(*; "btnClose"; (Form.isEditing & Form.canToggleClose))
        If (Form.todo.assigned_to=Form.userId)
            OBJECT SET ENTERABLE(*; "Input2"; obk enterable)
            OBJECT SET RGB COLORS(*; "Rectangle8"; 0xA1A1AA; 0xFFFFFF)
        Else 
            OBJECT SET ENTERABLE(*; "Input2"; obk not enterable not focusable)
            OBJECT SET RGB COLORS(*; "Rectangle8"; 0xD1D5DB; 0xE5E7EB)
        End if 
        If (Not(Form.canEdit))
            OBJECT SET ENTERABLE(*; "Input"; obk not enterable not focusable)
            OBJECT SET ENTERABLE(*; "Input1"; obk not enterable not focusable)
            OBJECT SET ENABLED(*; "btnAssignee"; False)
            OBJECT SET ENABLED(*; "btnPatient"; False)
            OBJECT SET ENABLED(*; "btnSave"; False)
            OBJECT SET RGB COLORS(*; "Rectangle"; 0xD1D5DB; 0xE5E7EB)
            OBJECT SET RGB COLORS(*; "Rectangle1"; 0xD1D5DB; 0xE5E7EB)
            OBJECT SET RGB COLORS(*; "Rectangle2"; 0xD1D5DB; 0xE5E7EB)
            OBJECT SET RGB COLORS(*; "Rectangle3"; 0xD1D5DB; 0xE5E7EB)
            OBJECT SET RGB COLORS(*; "Rectangle4"; 0xD1D5DB; 0xE5E7EB)
        Else 
            OBJECT SET RGB COLORS(*; "Rectangle"; 0xC0C0C0; 0xFFFFFF)
            OBJECT SET RGB COLORS(*; "Rectangle1"; 0xC0C0C0; 0xFFFFFF)
            OBJECT SET RGB COLORS(*; "Rectangle2"; 0xC0C0C0; 0xFFFFFF)
            OBJECT SET RGB COLORS(*; "Rectangle3"; 0xC0C0C0; 0xFFFFFF)
            OBJECT SET RGB COLORS(*; "Rectangle4"; 0xC0C0C0; 0xFFFFFF)
        End if 
        
    : (Form event code=On Clicked)
        Case of 
            : ((FORM Event.objectName="List Box") & Form.canEdit)
                LISTBOX GET CELL POSITION(*; "List Box"; $col; $row)
                If ($row>0)
                    $category:=Form.categories.at($row-1)
                    If ($category#Null)
                        $selection:=Form.selectedCategories.query("ID = :1"; $category.ID)
                        If ($selection.length>0)
                            LISTBOX SELECT ROWS(*; "List Box"; $selection; lk remove from selection)
                        Else 
                            $selection:=Form.categories.query("ID = :1"; $category.ID)
                            LISTBOX SELECT ROWS(*; "List Box"; $selection; lk add to selection)
                        End if 
                    End if 
                End if 
                
            : ((FORM Event.objectName="btnClose") & Form.isEditing & Form.canToggleClose)
                $todo:=ds.Todo.get(Form.todo.ID)
                If ($todo#Null)
                    If ($todo.completed_at=Null)
                        $todo.completed_at:=cs.Timestamp.me.now()
                    Else 
                        $todo.completed_at:=Null
                    End if 
                    $todo.save()
                    Form.todo:=$todo
                    Form.completedAtLabel:=Form.todo.completed_at ? [String(cs.Timestamp.me.stampToDate(Form.todo.completed_at)); String(cs.Timestamp.me.stampToTime(Form.todo.completed_at))].join(" - ") : ""
                    Form.canEdit:=((Form.todo.created_by=Form.userId) & (Form.todo.completed_at=Null))
                    Form.closeButtonLabel:=Form.todo.completed_at=Null ? "✔️ Clôturer" : "↩️ Rouvrir"
                    OBJECT SET TITLE(*; "btnClose"; Form.closeButtonLabel)
                    If (Form.canEdit)
                        OBJECT SET ENTERABLE(*; "Input"; obk enterable)
                        OBJECT SET ENTERABLE(*; "Input1"; obk enterable)
                        OBJECT SET ENABLED(*; "btnAssignee"; True)
                        OBJECT SET ENABLED(*; "btnPatient"; True)
                        OBJECT SET ENABLED(*; "btnSave"; True)
                        OBJECT SET RGB COLORS(*; "Rectangle"; 0xC0C0C0; 0xFFFFFF)
                        OBJECT SET RGB COLORS(*; "Rectangle1"; 0xC0C0C0; 0xFFFFFF)
                        OBJECT SET RGB COLORS(*; "Rectangle2"; 0xC0C0C0; 0xFFFFFF)
                        OBJECT SET RGB COLORS(*; "Rectangle3"; 0xC0C0C0; 0xFFFFFF)
                        OBJECT SET RGB COLORS(*; "Rectangle4"; 0xC0C0C0; 0xFFFFFF)
                    Else 
                        OBJECT SET ENTERABLE(*; "Input"; obk not enterable not focusable)
                        OBJECT SET ENTERABLE(*; "Input1"; obk not enterable not focusable)
                        OBJECT SET ENABLED(*; "btnAssignee"; False)
                        OBJECT SET ENABLED(*; "btnPatient"; False)
                        OBJECT SET ENABLED(*; "btnSave"; False)
                        OBJECT SET RGB COLORS(*; "Rectangle"; 0xD1D5DB; 0xE5E7EB)
                        OBJECT SET RGB COLORS(*; "Rectangle1"; 0xD1D5DB; 0xE5E7EB)
                        OBJECT SET RGB COLORS(*; "Rectangle2"; 0xD1D5DB; 0xE5E7EB)
                        OBJECT SET RGB COLORS(*; "Rectangle3"; 0xD1D5DB; 0xE5E7EB)
                        OBJECT SET RGB COLORS(*; "Rectangle4"; 0xD1D5DB; 0xE5E7EB)
                    End if 
                    If (Form.todo.assigned_to=Form.userId)
                        OBJECT SET ENTERABLE(*; "Input2"; obk enterable)
                        OBJECT SET RGB COLORS(*; "Rectangle8"; 0xA1A1AA; 0xFFFFFF)
                    Else 
                        OBJECT SET ENTERABLE(*; "Input2"; obk not enterable not focusable)
                        OBJECT SET RGB COLORS(*; "Rectangle8"; 0xD1D5DB; 0xE5E7EB)
                    End if 
                    ACCEPT
                End if 
        End case 
End case 
