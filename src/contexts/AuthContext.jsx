import React, { createContext, useState } from 'react';

const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null); // { role: 'volunteer' | 'organization', ... }

  const login = (userData) => {
    // If logging in as organization, assign a mock organizationId
    if (userData.role === 'organization' && !userData.organizationId) {
      // For demo, assign org 101 (matches mock jobs)
      setUser({ ...userData, organizationId: 101 });
    } else {
      setUser(userData);
    }
  };
  const logout = () => setUser(null);

  return (
    <AuthContext.Provider value={{ user, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
};

export { AuthContext }; 