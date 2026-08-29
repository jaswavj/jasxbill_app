import {
    faBars,
    faMoon,
    faRightFromBracket,
    faSun,
} from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome'
import { useDispatch, useSelector } from 'react-redux'
import { Link } from 'react-router-dom'
import { RootState } from '../../state/store'
import { useSidebar } from '../../context/SidebarContext'
import { routerPathNames } from '../../routes/routerPathNames'
import { authLogout } from '../../login/components/state/loginSlice'
import { routerBaseUrl } from '../../billingConfig'
import billingConfig from '../../billingConfig'
import { useThemeMode } from '../../theme/ThemeRoot'
import './header.css'

const Header = () => {
    const dispatch = useDispatch()
    const { toggleMobileSidebar, toggleSidebar, collapsed } = useSidebar()
    const { mode, toggleTheme } = useThemeMode()
    const loginData = useSelector((state: RootState) => state.loginData)
    const userName = loginData?.fullName?.trim() || loginData?.name?.trim() || 'Signed-in user'
    const userInitial = userName.charAt(0).toUpperCase()

    const handleLogout = () => {
        dispatch(authLogout())
        window.location.href = routerBaseUrl + '/login'
    }

    return (
        <div className="app-header-shell">
            <header className="app-header-content">
                <div className="header-left">
                    <button
                        type="button"
                        className="header-icon-btn header-menu-btn--mobile"
                        onClick={toggleMobileSidebar}
                        aria-label="Open navigation menu"
                    >
                        <FontAwesomeIcon icon={faBars} />
                    </button>
                    <button
                        type="button"
                        className={`header-icon-btn header-menu-btn--desktop${collapsed ? ' is-collapsed' : ''}`}
                        onClick={toggleSidebar}
                        aria-label="Toggle sidebar"
                    >
                        <FontAwesomeIcon icon={faBars} />
                    </button>
                    <Link to={routerPathNames.dashboard} className="header-brand" title="Home">
                        {billingConfig.appName}
                    </Link>
                </div>

                <div className="header-center" aria-hidden="true" />

                <div className="header-right">
                    <button
                        type="button"
                        className="header-icon-btn"
                        aria-label={mode === 'dark' ? 'Switch to light theme' : 'Switch to dark theme'}
                        title={mode === 'dark' ? 'Light theme' : 'Dark theme'}
                        onClick={toggleTheme}
                    >
                        <FontAwesomeIcon icon={mode === 'dark' ? faSun : faMoon} />
                    </button>

                    <div className="header-profile" title={userName}>
                        <span className="header-avatar">{userInitial}</span>
                        <span className="header-user-name">{userName}</span>
                    </div>

                    <button
                        type="button"
                        className="header-icon-btn"
                        onClick={handleLogout}
                        aria-label="Logout"
                        title="Logout"
                    >
                        <FontAwesomeIcon icon={faRightFromBracket} />
                    </button>
                </div>
            </header>
        </div>
    )
}

export default Header
