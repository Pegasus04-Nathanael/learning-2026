# Definition for singly-linked list.
class ListNode(object):
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next
    
    def affichage(self):
        chiffres = []
        courant = self
        while courant:
            chiffres.append(str(courant.val))
            courant = courant.next
        
        # La liste est [Unité, Dizaine, Centaine...] (ex: ['9', '5', '2'])
        # Pour afficher le nombre "259", il faut inverser et joindre
        nombre_lisible = "".join(chiffres[::-1])
        print(f"Liste: {' -> '.join(chiffres)}  |  Nombre réel: {nombre_lisible}")

class Solution(object):
    def addTwoNumbers(self, l1 = ListNode , l2 = ListNode):
        
        tmpa, tmpb = 0,0
        currentNodeA , currentNodeB = l1 , l2
        sortie  = ListNode()
        tmp = sortie
        carry = 0

        while currentNodeA or currentNodeB or carry:
            #print(currentNodeA.val)
            #print(currentNodeB.val)
            #print("Yo")
            if currentNodeA :
                tmpa = currentNodeA.val
                currentNodeA = currentNodeA.next
            else :
                tmpa = 0
            if currentNodeB :
                tmpb = currentNodeB.val
                currentNodeB = currentNodeB.next
            else :
                tmpb = 0

            valeur = tmpa + tmpb + carry
            carry = valeur // 10
            digit = valeur % 10

            tmp.next = ListNode(digit)
            tmp = tmp.next

            #Pour debugger et voir le digit qui a ete enregistre dans la liste
            print(digit)

        return sortie.next
                

        
    

sol = Solution()
tA1 = ListNode(9)
tA2 = ListNode(5)
tA3 = ListNode(2)

tB1 = ListNode(1)
tB2 = ListNode(2)
tB3 = ListNode(3)


tA1.next = tA2
tA2.next = tA3

tB1.next = tB2
tB2.next = tB3

result = sol.addTwoNumbers(tA1, tB1)

# TEST
print("\n--- TEST AFFICHAGE ---")
#print("A = ")
result.affichage() # Va afficher: Liste: 9 -> 5 -> 2 | Nombre réel: 259
