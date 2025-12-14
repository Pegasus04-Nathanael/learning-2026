"""
1. Two Sum - Easy
https://leetcode.com/problems/two-sum/

Given an array of integers nums and an integer target, 
return indices of the two numbers that add up to target.

Solution: HashMap approach - O(n) time, O(n) space
"""

class Solution:
    def twoSum(self, nums, target):
        seen = {}
        
        for i, num in enumerate(nums):
            complement = target - num
            if complement in seen:
                return [seen[complement], i]
            seen[num] = i
        
        return []

# Test cases
if __name__ == "__main__":
    sol = Solution()
    
    # Test 1
    assert sol.twoSum([2,7,11,15], 9) == [0,1]
    
    # Test 2
    assert sol.twoSum([3,2,4], 6) == [1,2]
    
    # You ca test here
    
    print("✅ All tests passed!")