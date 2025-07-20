import React, { createContext, useState, useEffect } from 'react';
import { volunteerService, organizerService } from '../api/services.js';
import { getAuthToken, clearAuthToken } from '../api/client.js';

const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const [isAuthenticated, setIsAuthenticated] = useState(false);

  // Check for existing token on app start
  useEffect(() => {
    const checkAuthStatus = async () => {
      const token = getAuthToken();
      if (token) {
        try {
          // Try to fetch user profile to validate token and determine role
          // We'll try volunteer first, then organizer if that fails
          let profileResponse = await volunteerService.getProfile();
          
          if (profileResponse.success && profileResponse.data) {
            setUser({
              ...profileResponse.data,
              role: 'volunteer',
              token
            });
            setIsAuthenticated(true);
          } else {
            // Try organizer profile
            profileResponse = await organizerService.getProfile();
            
            if (profileResponse.success && profileResponse.data) {
              setUser({
                ...profileResponse.data,
                role: 'organization',
                organizationId: profileResponse.data.id, // Map id to organizationId for backward compatibility
                token
              });
              setIsAuthenticated(true);
            } else {
              // Token is invalid, clear it
              clearAuthToken();
              setUser(null);
              setIsAuthenticated(false);
            }
          }
        } catch (error) {
          console.error('Auth check failed:', error);
          clearAuthToken();
          setUser(null);
          setIsAuthenticated(false);
        }
      } else {
        setUser(null);
        setIsAuthenticated(false);
      }
      setLoading(false);
    };

    checkAuthStatus();
  }, []);

  const login = async (loginData) => {
    try {
      setLoading(true);
      
      // loginData should contain: { role, email, token }
      // Now fetch the full user profile
      let profileResponse;
      
      if (loginData.role === 'volunteer') {
        profileResponse = await volunteerService.getProfile();
        
        if (profileResponse.success && profileResponse.data) {
          const userData = {
            ...profileResponse.data,
            role: 'volunteer',
            email: loginData.email,
            token: loginData.token
          };
          setUser(userData);
          setIsAuthenticated(true);
          return { success: true, user: userData };
        }
      } else if (loginData.role === 'organization') {
        profileResponse = await organizerService.getProfile();
        
        if (profileResponse.success && profileResponse.data) {
          const userData = {
            ...profileResponse.data,
            role: 'organization',
            organizationId: profileResponse.data.id, // Map id to organizationId for backward compatibility
            email: loginData.email,
            token: loginData.token
          };
          setUser(userData);
          setIsAuthenticated(true);
          return { success: true, user: userData };
        }
      }
      
      // If we get here, profile fetch failed
      return { success: false, error: 'Failed to fetch user profile' };
      
    } catch (error) {
      console.error('Login error:', error);
      return { success: false, error: error.message };
    } finally {
      setLoading(false);
    }
  };

  const logout = () => {
    clearAuthToken();
    setUser(null);
    setIsAuthenticated(false);
  };

  const updateUserProfile = (updatedData) => {
    if (user) {
      setUser({ ...user, ...updatedData });
    }
  };

  return (
    <AuthContext.Provider value={{ 
      user, 
      login, 
      logout, 
      loading, 
      isAuthenticated,
      updateUserProfile
    }}>
      {children}
    </AuthContext.Provider>
  );
};

export { AuthContext }; 