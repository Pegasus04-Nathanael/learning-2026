class Solution(object):
    def lengthOfLongestSubstring(self, s = str):

        map_for_char = {}     
        max_len = 0
        start = 0
        #best_start = 0

        for i in range(len(s)):
            tmp = s[i]

            if tmp in map_for_char and map_for_char[tmp]  >= start :
                start = map_for_char[tmp] + 1
                #print('start : ' , start)
            map_for_char[tmp] = i
            #print(s[i])
            #print("debut : " + s[start] + "  indice : ", start)

            current_len = i - start + 1
            #print("current-len" ,current_len)
        
            if current_len > max_len :
                #print(s[i])
                max_len = current_len
                best_start = start
            
        premier_caractere = s[best_start]
        mot_entier = s[best_start : best_start + max_len]
        
        #print(f"Le mot le plus long commence par '{premier_caractere}' et c'est : {mot_entier}")
            
        return max_len

sol = Solution()
print(sol.lengthOfLongestSubstring("zaaxk"))
        
    